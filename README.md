# Caching JSON Encoder For Rails (PoC)

The goal of this proof-of-concept is to speed up the JSON pipeline in Rails with
a new JSON encoder that is optimized for Rails' needs. The tentative target is
to release this with Rails 5, but the encoder should be usable with Rails 4.1 as
well.

## Background

Since Rails 4.1, Rails internally uses the JSON gem from stdlib to encode your
Ruby objects into JSON. This improved performance significantly, but it is still
off by at least an order of magnitude in most cases, compared to the "raw"
encoding performance of other JSON encoders for Ruby.

This can mainly be attributed to the mismatching APIs between Rails and the JSON
gem – Rails expects developers to implement an `as_json` hook to describe how
the object should be translated into JSON primitives, whereas the JSON gem uses
a completely different mechanism and does not consider `as_json` at all. This
forces us to do a "pre-encoding" step to resolve the `as_json` hooks on the tree
before handing it off to the JSON gem for the actual encoding. (This sometimes
results in multiple passes on the tree, because sometimes to `as_json` hooks
themselves does a deep `as_json` pass as well.)

With a custom JSON encoder, we should be able to do a single-pass encoding and
resolve any `as_json` hooks while traversing the tree for encoding.

### Caching

Another key observation for this project is that a lot of these work are being
duplicated per-request. JSON encoding itself is pretty slow, so even with a fast
encoder, doing a `JSON.generate( ... )` on the same objects on every request is
still needlessly wasteful if the objects themselves didn't change (thus the
result of the encoding will be the same).

Several JSON builder/serializer libraries already supports caching, but they are
only able to cache the Ruby representation (i.e. the result of the resolved
`as_json`s – containing hashes, arrays, etc), so they still need to go through
the encoding process every request.

We should be able to leverage our custom encoder and cache the encoded strings
directly. Further more, we should be able to do this Russian-doll style – for
example, if one of the entries in a long array has changed, we should only need
to re-encode that one object and stitch it together with the cached strings to
emit the final JSON, without having to re-encode the other objects.

## Current Status

See `config/initializers/cached_json_encoder.rb` for the PoC implementation.

See `app/controllers/stories_controller.rb` and `app/serializers` for the test
cases. (This uses a simplified, `AM::S`-like serializer classes, but I don't see
why the same technique cannot be applied to JBuilder, etc.)

See `RESULTS.md` for the current benchmark results. All the benchmarks are ran
using Ruby 2.2.0 with Apache Bench (which is to say that it's testing at the
system level with the entire stack, not a micro-benchmark for just the encoding
performance – i.e. this is what the users will in-theory notice).

Summary:

* The raw encoding performance of the new encoder (i.e. Baseline vs 100% MISS)
  is <= 20% slower than the current encoder shipped with Rails 4.1+.

* Obviously, when you have the outer-most tree cached, this is very fast. In
  this scenario (i.e. Baseline vs 100% HIT) the encoder is anywhere from 50% to
  over 10X faster. (Relative performance is not very meaningful here, because
  in this case the new encoder's performance is flat regardless of the payload.)

* The cache-reuse ("Russian Doll" caching) test is a bit disappointing at the
  moment. The generation is ~15% slower compared to the baseline (re-encode all
  the things using the current encoder). Ideally, we want to work towards having
  this benchmark beating the current implementation.

## Future Work

* Make sure Rails' JSON encoding tests pass with the new encoder
* Investigate the hotspots and optimize the Ruby implementation
* Explore building a "native" encoder (C extenstion)
