# Is JSON Encoding in Rails finally fast yet?

Maybe!

## JSON Gem Encoder (Current Rails 4.1+)

```
$ RAILS_ENV=production rake db:create db:migrate db:seed

$ RAILS_ENV=production rails s

$ ab -n 1000 http://localhost:3000/stories.json (Index)

Percentage of the requests served within a certain time (ms)
  50%     10
  66%     10
  75%     11
  80%     11
  90%     12
  95%     13
  98%     15
  99%     15
 100%     17 (longest request)


$ ab -n 1000 http://localhost:3000/stories/9146006.json (Small article, 2 comments)

Percentage of the requests served within a certain time (ms)
  50%      5
  66%      5
  75%      5
  80%      5
  90%      6
  95%      7
  98%      7
  99%      8
 100%     10 (longest request)


$ ab -n 1000 http://localhost:3000/stories/9145007.json (Medium article, 141 comments)

Percentage of the requests served within a certain time (ms)
  50%     36
  66%     37
  75%     38
  80%     38
  90%     40
  95%     42
  98%     44
  99%     45
 100%     52 (longest request)


$ ab -n 1000 http://localhost:3000/stories/9145126.json (Long article, 121 comments)

Percentage of the requests served within a certain time (ms)
  50%     31
  66%     32
  75%     33
  80%     34
  90%     35
  95%     36
  98%     38
  99%     38
 100%     44 (longest request)


$ ab -n 1000 http://localhost:3000/stories/9144271.json (No article, 136 comments)

Percentage of the requests served within a certain time (ms)
  50%     33
  66%     35
  75%     35
  80%     36
  90%     37
  95%     39
  98%     40
  99%     41
 100%     50 (longest request)
```

* * *

## Caching Encoder + Null Store

```
$ RAILS_ENV=production rake db:create db:migrate db:seed

$ RAILS_ENV=production CACHE=1 NULL_STORE=1 rails s

$ ab -n 1000 http://localhost:3000/stories.json (Index)

Percentage of the requests served within a certain time (ms)
  50%     12
  66%     14
  75%     15
  80%     15
  90%     16
  95%     17
  98%     18
  99%     19
 100%     21 (longest request)


$ ab -n 1000 http://localhost:3000/stories/9146006.json (Small article, 2 comments)

Percentage of the requests served within a certain time (ms)
  50%      5
  66%      6
  75%      6
  80%      6
  90%      7
  95%      7
  98%      8
  99%      8
 100%     12 (longest request)


$ ab -n 1000 http://localhost:3000/stories/9145007.json (Medium article, 141 comments)

Percentage of the requests served within a certain time (ms)
  50%     42
  66%     44
  75%     45
  80%     45
  90%     47
  95%     48
  98%     51
  99%     52
 100%     57 (longest request)


$ ab -n 1000 http://localhost:3000/stories/9145126.json (Long article, 121 comments)

Percentage of the requests served within a certain time (ms)
  50%     38
  66%     40
  75%     41
  80%     41
  90%     43
  95%     45
  98%     47
  99%     48
 100%     55 (longest request)


$ ab -n 1000 http://localhost:3000/stories/9144271.json (No article, 136 comments)

Percentage of the requests served within a certain time (ms)
  50%     42
  66%     43
  75%     44
  80%     45
  90%     46
  95%     48
  98%     50
  99%     50
 100%     59 (longest request)
```

## Caching Encoder + Memory Store

```
$ RAILS_ENV=production rake db:create db:migrate db:seed

$ RAILS_ENV=production CACHE=1 rails s

$ ab -n 1000 http://localhost:3000/stories.json (Index)

Percentage of the requests served within a certain time (ms)
  50%      5
  66%      5
  75%      5
  80%      5
  90%      6
  95%      7
  98%      8
  99%      8
 100%     47 (longest request)


$ ab -n 1000 http://localhost:3000/stories/9146006.json (Small article, 2 comments)

Percentage of the requests served within a certain time (ms)
  50%      3
  66%      3
  75%      3
  80%      3
  90%      4
  95%      4
  98%      5
  99%      5
 100%     27 (longest request)


$ ab -n 1000 http://localhost:3000/stories/9145007.json (Medium article, 141 comments)

Percentage of the requests served within a certain time (ms)
  50%      4
  66%      4
  75%      4
  80%      4
  90%      4
  95%      4
  98%      5
  99%      6
 100%     45 (longest request)


$ ab -n 1000 http://localhost:3000/stories/9145126.json (Long article, 121 comments)

Percentage of the requests served within a certain time (ms)
  50%      4
  66%      4
  75%      4
  80%      4
  90%      5
  95%      5
  98%      6
  99%      7
 100%     44 (longest request)


$ ab -n 1000 http://localhost:3000/stories/9144271.json (No article, 136 comments)

Percentage of the requests served within a certain time (ms)
  50%      3
  66%      4
  75%      4
  80%      4
  90%      4
  95%      4
  98%      5
  99%      6
 100%    118 (longest request)
```

* * *

## TODO: Test Reusing Fragments ("Russian Doll")

...
