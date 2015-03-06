require 'active_support/json/encoding'

if ENV['NULL_STORE']
  $cache = ActiveSupport::Cache::NullStore.new
else
  $cache = ActiveSupport::Cache::MemoryStore.new
end

module ActiveSupport
  module JSON
    module Encoding
      module Cachable
        def cache_key
          nil
        end
      end

      class CachingEncoder
        def initialize(*)
        end

        def encode(value)
          fetch_or_encode_value(value, '')
        end

        private
          ESCAPED_CHARS = {
            "\u2028" => '\u2028',
            "\u2029" => '\u2029',
            '>'      => '\u003e',
            '<'      => '\u003c',
            '&'      => '\u0026',
          }

          ESCAPE_REGEX_WITH_HTML_ENTITIES = /[\u2028\u2029><&]/u
          ESCAPE_REGEX_WITHOUT_HTML_ENTITIES = /[\u2028\u2029]/u

          private_constant :ESCAPED_CHARS,
            :ESCAPE_REGEX_WITH_HTML_ENTITIES,
            :ESCAPE_REGEX_WITHOUT_HTML_ENTITIES

          def fetch_or_encode_value(value, buffer)
            if Cachable === value
              buffer << $cache.fetch(value.cache_key) { encode_value(value.as_json, '') }
            else
              encode_value(value.as_json, buffer)
            end
          end

          def encode_value(value, buffer)
            case value
            when String
              encode_string(value, buffer)
            when Symbol
              encode_string(value.to_s, buffer)
            when Float
              buffer << (value.finite? ? value.to_s : 'null'.freeze)
            when Numeric
              buffer << value.to_s
            when NilClass
              buffer << 'null'.freeze
            when TrueClass
              buffer << 'true'.freeze
            when FalseClass
              buffer << 'false'.freeze
            when Hash
              encode_hash(value, buffer)
            when Array
              encode_array(value, buffer)
            else
              fetch_or_encode_value(value, buffer)
            end
          end

          def encode_string(str, buffer)
            escaped = ::JSON.fast_generate(str, quirks_mode: true)

            if Encoding.escape_html_entities_in_json
              escaped.gsub!(ESCAPE_REGEX_WITH_HTML_ENTITIES, ESCAPED_CHARS)
            else
              escaped.gsub!(ESCAPE_REGEX_WITHOUT_HTML_ENTITIES, ESCAPED_CHARS)
            end

            buffer << escaped
          end

          def encode_hash(hash, buffer)
            buffer << '{'.freeze

            first = true

            hash.each_pair do |key, value|
              if first
                first = false
              else
                buffer << ','.freeze
              end

              if String === key
                encode_string(key, buffer)
              else
                encode_string(key.to_s, buffer)
              end

              buffer << ':'.freeze

              fetch_or_encode_value(value, buffer)
            end

            buffer << '}'.freeze
          end

          def encode_array(array, buffer)
            buffer << '['.freeze

            first = true

            array.each do |value|
              if first
                first = false
              else
                buffer << ','.freeze
              end

              fetch_or_encode_value(value, buffer)
            end

            buffer << ']'.freeze
          end
      end

      if ENV['CACHE']
        self.json_encoder = CachingEncoder
      end
    end
  end
end
