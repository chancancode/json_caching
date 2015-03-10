require "json"
require "pp"

def run(command)
  puts "$ #{command}"
  system command
end

def assert(command)
  puts "$ #{command}"
  system(command) || abort("Command exited with status #{$?}")
end

def diff_json(expected, actual)
  if JSON.parse(expected) != JSON.parse(actual)
    $stderr.puts "Expected:\n\n"
    $stderr.puts expected.pretty_inspect
    $stderr.puts "\n\n"
    $stderr.puts "Actual:\n\n"
    $stderr.puts actual.pretty_inspect

    abort
  end
end

puts "```"
assert "RAILS_ENV=production rake db:drop db:create db:migrate db:seed 1> /dev/null"
puts "```"

BASIC = {
  'Index'                        => 'http://localhost:3000/stories.json',
  'Small article, 2 comments'    => 'http://localhost:3000/stories/9146006.json',
  'Medium article, 141 comments' => 'http://localhost:3000/stories/9145007.json',
  'Long article, 121 comments'   => 'http://localhost:3000/stories/9145126.json',
  'No article, 136 comments'     => 'http://localhost:3000/stories/9144271.json'
}

puts "\n\n# Basic Tests"

def run_basic_tests(name, params = '')
  puts "\n## #{name}\n\n"

  puts "```"
  assert "RAILS_ENV=production #{params} rails server --daemon 1> /dev/null"
  puts "```"

  BASIC.each_pair do |name, url|
    puts "\n### #{name}\n\n"

    puts "```"

    file = URI.parse(url).path
    diff_json File.read("test/fixtures#{file}"), `curl #{url}`
    run "ab -n 1000 #{url} | tail -n 11"

    puts "```"
  end

  puts "\n```"

  assert "kill #{ `cat tmp/pids/server.pid` }"

  puts "```"
end

run_basic_tests('Baseline (JSON Gem Encoder)')
run_basic_tests('100% MISS (Caching Encoder + Null Store)', 'CACHE=1 NULL_STORE=1')
run_basic_tests('100% HIT (Caching Encoder + Memory Store)', 'CACHE=1')

WITH_INVALIDATION = {
  'Index'                                         => 'http://localhost:3000/stories.json?expire_story=9144271',

  'Small article, 2 comments (expire story)'      => 'http://localhost:3000/stories/9146006.json?expire_story=9146006',
  'Small article, 2 comments (expire comment)'    => 'http://localhost:3000/stories/9146006.json?expire_comment=9147664',
  'Small article, 2 comments (expire article)'    => 'http://localhost:3000/stories/9146006.json?expire_article=18',

  'Medium article, 141 comments (expire story)'   => 'http://localhost:3000/stories/9145007.json?expire_story=9145007',
  'Medium article, 141 comments (expire comment)' => 'http://localhost:3000/stories/9145007.json?expire_comment=9145058',
  'Medium article, 141 comments (expire article)' => 'http://localhost:3000/stories/9145007.json?expire_article=8',

  'Long article, 121 comments (expire story)'     => 'http://localhost:3000/stories/9145126.json?expire_story=9145126',
  'Long article, 121 comments (expire comment)'   => 'http://localhost:3000/stories/9145126.json?expire_comment=9145650',
  'Long article, 121 comments (expire article)'   => 'http://localhost:3000/stories/9145126.json?expire_article=9',

  'No article, 136 comments (expire story)'       => 'http://localhost:3000/stories/9144271.json?expire_story=9144271',
  'No article, 136 comments (expire comment)'     => 'http://localhost:3000/stories/9144271.json?expire_comment=9144509'
}

puts "\n\n# Cache Reuse (Russian-doll)"

def run_invalidation_tests(name, params = '')
  puts "\n## #{name}\n\n"

  puts "```"
  assert "RAILS_ENV=production #{params} rails server --daemon 1> /dev/null"
  puts "```"

  WITH_INVALIDATION.each_pair do |name, url|
    puts "\n### #{name}\n\n"

    puts "```"

    file = URI.parse(url).path
    diff_json File.read("test/fixtures#{file}"), `curl #{url}`
    run "ab -n 1000 #{url} | tail -n 11"

    puts "```"
  end

  puts "\n```"

  assert "kill #{ `cat tmp/pids/server.pid` }"

  puts "```"
end

run_invalidation_tests('Baseline (JSON Gem Encoder)')
run_invalidation_tests('Caching Encoder', 'CACHE=1')
