# Basic Tests

## Baseline (JSON Gem Encoder)

```
$ RAILS_ENV=production rake db:drop db:create db:migrate db:seed 1> /dev/null
$ RAILS_ENV=production  rails server --daemon 1> /dev/null
```

### Index

```
$ if ! (curl http://localhost:3000/stories.json | diff - test/fixtures//stories.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     14
  66%     14
  75%     15
  80%     15
  90%     16
  95%     17
  98%     18
  99%     20
 100%     34 (longest request)
```

### Small article, 2 comments

```
$ if ! (curl http://localhost:3000/stories/9146006.json | diff - test/fixtures//stories/9146006.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories/9146006.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%      6
  66%      6
  75%      6
  80%      6
  90%      7
  95%      7
  98%      9
  99%      9
 100%     11 (longest request)
```

### Medium article, 141 comments

```
$ if ! (curl http://localhost:3000/stories/9145007.json | diff - test/fixtures//stories/9145007.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories/9145007.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     52
  66%     52
  75%     53
  80%     54
  90%     56
  95%     57
  98%     59
  99%     61
 100%     64 (longest request)
```

### Long article, 121 comments

```
$ if ! (curl http://localhost:3000/stories/9145126.json | diff - test/fixtures//stories/9145126.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories/9145126.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     47
  66%     47
  75%     48
  80%     49
  90%     51
  95%     52
  98%     55
  99%     57
 100%     71 (longest request)
```

### No article, 136 comments

```
$ if ! (curl http://localhost:3000/stories/9144271.json | diff - test/fixtures//stories/9144271.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories/9144271.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     51
  66%     51
  75%     52
  80%     53
  90%     55
  95%     56
  98%     58
  99%     59
 100%     65 (longest request)
```

```
$ kill 63095
```

## 100% MISS (Caching Encoder + Null Store)

```
$ RAILS_ENV=production rake db:drop db:create db:migrate db:seed 1> /dev/null
$ RAILS_ENV=production CACHE=1 NULL_STORE=1 rails server --daemon 1> /dev/null
```

### Index

```
$ if ! (curl http://localhost:3000/stories.json | diff - test/fixtures//stories.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     17
  66%     18
  75%     18
  80%     19
  90%     21
  95%     22
  98%     23
  99%     24
 100%     48 (longest request)
```

### Small article, 2 comments

```
$ if ! (curl http://localhost:3000/stories/9146006.json | diff - test/fixtures//stories/9146006.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories/9146006.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%      7
  66%      7
  75%      7
  80%      7
  90%      8
  95%      8
  98%     10
  99%     10
 100%     12 (longest request)
```

### Medium article, 141 comments

```
$ if ! (curl http://localhost:3000/stories/9145007.json | diff - test/fixtures//stories/9145007.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories/9145007.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     62
  66%     62
  75%     63
  80%     64
  90%     66
  95%     68
  98%     70
  99%     71
 100%     80 (longest request)
```

### Long article, 121 comments

```
$ if ! (curl http://localhost:3000/stories/9145126.json | diff - test/fixtures//stories/9145126.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories/9145126.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     56
  66%     56
  75%     57
  80%     57
  90%     60
  95%     61
  98%     62
  99%     63
 100%     76 (longest request)
```

### No article, 136 comments

```
$ if ! (curl http://localhost:3000/stories/9144271.json | diff - test/fixtures//stories/9144271.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories/9144271.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     60
  66%     61
  75%     61
  80%     62
  90%     65
  95%     66
  98%     67
  99%     70
 100%     76 (longest request)
```

```
$ kill 63155
```

## 100% HIT (Caching Encoder + Memory Store)

```
$ RAILS_ENV=production rake db:drop db:create db:migrate db:seed 1> /dev/null
$ RAILS_ENV=production CACHE=1 rails server --daemon 1> /dev/null
```

### Index

```
$ if ! (curl http://localhost:3000/stories.json | diff - test/fixtures//stories.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%      8
  66%      9
  75%      9
  80%     10
  90%     11
  95%     12
  98%     13
  99%     18
 100%     68 (longest request)
```

### Small article, 2 comments

```
$ if ! (curl http://localhost:3000/stories/9146006.json | diff - test/fixtures//stories/9146006.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories/9146006.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%      4
  66%      4
  75%      4
  80%      4
  90%      5
  95%      5
  98%      6
  99%      6
 100%      7 (longest request)
```

### Medium article, 141 comments

```
$ if ! (curl http://localhost:3000/stories/9145007.json | diff - test/fixtures//stories/9145007.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories/9145007.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%      4
  66%      4
  75%      5
  80%      5
  90%      5
  95%      6
  98%      7
  99%      7
 100%     25 (longest request)
```

### Long article, 121 comments

```
$ if ! (curl http://localhost:3000/stories/9145126.json | diff - test/fixtures//stories/9145126.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories/9145126.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%      4
  66%      4
  75%      4
  80%      5
  90%      5
  95%      6
  98%      6
  99%      7
 100%      9 (longest request)
```

### No article, 136 comments

```
$ if ! (curl http://localhost:3000/stories/9144271.json | diff - test/fixtures//stories/9144271.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories/9144271.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%      4
  66%      4
  75%      4
  80%      4
  90%      5
  95%      5
  98%      6
  99%      6
 100%      7 (longest request)
```

```
$ kill 63220
```
# Cache Reuse (Russian-doll)

## Baseline (JSON Gem Encoder)

```
$ RAILS_ENV=production rake db:drop db:create db:migrate db:seed 1> /dev/null
$ RAILS_ENV=production  rails server --daemon 1> /dev/null
```

### Index

```
$ if ! (curl http://localhost:3000/stories.json?expire_story=9144271 | diff - test/fixtures/stories.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories.json?expire_story=9144271 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     17
  66%     18
  75%     19
  80%     20
  90%     21
  95%     22
  98%     23
  99%     24
 100%     35 (longest request)
```

### Small article, 2 comments (expire story)

```
$ if ! (curl http://localhost:3000/stories/9146006.json?expire_story=9146006 | diff - test/fixtures/stories/9146006.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories/9146006.json?expire_story=9146006 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%      9
  66%      9
  75%      9
  80%     10
  90%     10
  95%     11
  98%     12
  99%     13
 100%     27 (longest request)
```

### Small article, 2 comments (expire comment)

```
$ if ! (curl http://localhost:3000/stories/9146006.json?expire_comment=9147664 | diff - test/fixtures/stories/9146006.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories/9146006.json?expire_comment=9147664 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     10
  66%     11
  75%     11
  80%     12
  90%     12
  95%     13
  98%     14
  99%     15
 100%     17 (longest request)
```

### Small article, 2 comments (expire article)

```
$ if ! (curl http://localhost:3000/stories/9146006.json?expire_article=18 | diff - test/fixtures/stories/9146006.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories/9146006.json?expire_article=18 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%      9
  66%      9
  75%      9
  80%     10
  90%     11
  95%     11
  98%     12
  99%     14
 100%     19 (longest request)
```

### Medium article, 141 comments (expire story)

```
$ if ! (curl http://localhost:3000/stories/9145007.json?expire_story=9145007 | diff - test/fixtures/stories/9145007.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories/9145007.json?expire_story=9145007 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     57
  66%     58
  75%     59
  80%     59
  90%     61
  95%     62
  98%     65
  99%     66
 100%     71 (longest request)
```

### Medium article, 141 comments (expire comment)

```
$ if ! (curl http://localhost:3000/stories/9145007.json?expire_comment=9145058 | diff - test/fixtures/stories/9145007.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories/9145007.json?expire_comment=9145058 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     59
  66%     60
  75%     61
  80%     61
  90%     63
  95%     65
  98%     66
  99%     68
 100%     75 (longest request)
```

### Medium article, 141 comments (expire article)

```
$ if ! (curl http://localhost:3000/stories/9145007.json?expire_article=8 | diff - test/fixtures/stories/9145007.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories/9145007.json?expire_article=8 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     57
  66%     58
  75%     59
  80%     59
  90%     61
  95%     63
  98%     65
  99%     66
 100%     70 (longest request)
```

### Long article, 121 comments (expire story)

```
$ if ! (curl http://localhost:3000/stories/9145126.json?expire_story=9145126 | diff - test/fixtures/stories/9145126.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories/9145126.json?expire_story=9145126 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     52
  66%     53
  75%     54
  80%     54
  90%     56
  95%     57
  98%     59
  99%     61
 100%     68 (longest request)
```

### Long article, 121 comments (expire comment)

```
$ if ! (curl http://localhost:3000/stories/9145126.json?expire_comment=9145650 | diff - test/fixtures/stories/9145126.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories/9145126.json?expire_comment=9145650 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     54
  66%     55
  75%     56
  80%     56
  90%     57
  95%     58
  98%     60
  99%     62
 100%     65 (longest request)
```

### Long article, 121 comments (expire article)

```
$ if ! (curl http://localhost:3000/stories/9145126.json?expire_article=9 | diff - test/fixtures/stories/9145126.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories/9145126.json?expire_article=9 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     52
  66%     53
  75%     54
  80%     54
  90%     56
  95%     57
  98%     59
  99%     60
 100%     69 (longest request)
```

### No article, 136 comments (expire story)

```
$ if ! (curl http://localhost:3000/stories/9144271.json?expire_story=9144271 | diff - test/fixtures/stories/9144271.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories/9144271.json?expire_story=9144271 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     56
  66%     58
  75%     58
  80%     59
  90%     60
  95%     62
  98%     64
  99%     65
 100%    107 (longest request)
```

### No article, 136 comments (expire comment)

```
$ if ! (curl http://localhost:3000/stories/9144271.json?expire_comment=9144509 | diff - test/fixtures/stories/9144271.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories/9144271.json?expire_comment=9144509 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     58
  66%     60
  75%     60
  80%     61
  90%     62
  95%     64
  98%     65
  99%     66
 100%     71 (longest request)
```

```
$ kill 63268
```

## Caching Encoder

```
$ RAILS_ENV=production rake db:drop db:create db:migrate db:seed 1> /dev/null
$ RAILS_ENV=production CACHE=1 rails server --daemon 1> /dev/null
```

### Index

```
$ if ! (curl http://localhost:3000/stories.json?expire_story=9144271 | diff - test/fixtures/stories.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories.json?expire_story=9144271 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     21
  66%     22
  75%     23
  80%     23
  90%     24
  95%     25
  98%     27
  99%     28
 100%     40 (longest request)
```

### Small article, 2 comments (expire story)

```
$ if ! (curl http://localhost:3000/stories/9146006.json?expire_story=9146006 | diff - test/fixtures/stories/9146006.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories/9146006.json?expire_story=9146006 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%      9
  66%     10
  75%     10
  80%     11
  90%     11
  95%     12
  98%     13
  99%     15
 100%     28 (longest request)
```

### Small article, 2 comments (expire comment)

```
$ if ! (curl http://localhost:3000/stories/9146006.json?expire_comment=9147664 | diff - test/fixtures/stories/9146006.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories/9146006.json?expire_comment=9147664 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     11
  66%     11
  75%     12
  80%     12
  90%     13
  95%     14
  98%     16
  99%     17
 100%     20 (longest request)
```

### Small article, 2 comments (expire article)

```
$ if ! (curl http://localhost:3000/stories/9146006.json?expire_article=18 | diff - test/fixtures/stories/9146006.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories/9146006.json?expire_article=18 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%      9
  66%     10
  75%     10
  80%     11
  90%     11
  95%     12
  98%     13
  99%     16
 100%     19 (longest request)
```

### Medium article, 141 comments (expire story)

```
$ if ! (curl http://localhost:3000/stories/9145007.json?expire_story=9145007 | diff - test/fixtures/stories/9145007.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories/9145007.json?expire_story=9145007 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     66
  66%     68
  75%     69
  80%     70
  90%     72
  95%     74
  98%     76
  99%     78
 100%    135 (longest request)
```

### Medium article, 141 comments (expire comment)

```
$ if ! (curl http://localhost:3000/stories/9145007.json?expire_comment=9145058 | diff - test/fixtures/stories/9145007.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories/9145007.json?expire_comment=9145058 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     68
  66%     69
  75%     70
  80%     71
  90%     73
  95%     75
  98%     76
  99%     77
 100%     89 (longest request)
```

### Medium article, 141 comments (expire article)

```
$ if ! (curl http://localhost:3000/stories/9145007.json?expire_article=8 | diff - test/fixtures/stories/9145007.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories/9145007.json?expire_article=8 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     66
  66%     68
  75%     68
  80%     69
  90%     71
  95%     73
  98%     75
  99%     76
 100%     82 (longest request)
```

### Long article, 121 comments (expire story)

```
$ if ! (curl http://localhost:3000/stories/9145126.json?expire_story=9145126 | diff - test/fixtures/stories/9145126.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories/9145126.json?expire_story=9145126 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     59
  66%     60
  75%     61
  80%     62
  90%     64
  95%     65
  98%     67
  99%     69
 100%     76 (longest request)
```

### Long article, 121 comments (expire comment)

```
$ if ! (curl http://localhost:3000/stories/9145126.json?expire_comment=9145650 | diff - test/fixtures/stories/9145126.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories/9145126.json?expire_comment=9145650 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     61
  66%     62
  75%     63
  80%     64
  90%     66
  95%     68
  98%     70
  99%     71
 100%     75 (longest request)
```

### Long article, 121 comments (expire article)

```
$ if ! (curl http://localhost:3000/stories/9145126.json?expire_article=9 | diff - test/fixtures/stories/9145126.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories/9145126.json?expire_article=9 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     60
  66%     61
  75%     62
  80%     62
  90%     64
  95%     66
  98%     68
  99%     69
 100%     79 (longest request)
```

### No article, 136 comments (expire story)

```
$ if ! (curl http://localhost:3000/stories/9144271.json?expire_story=9144271 | diff - test/fixtures/stories/9144271.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories/9144271.json?expire_story=9144271 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     65
  66%     67
  75%     68
  80%     68
  90%     70
  95%     73
  98%     76
  99%     78
 100%     95 (longest request)
```

### No article, 136 comments (expire comment)

```
$ if ! (curl http://localhost:3000/stories/9144271.json?expire_comment=9144509 | diff - test/fixtures/stories/9144271.json); then exit $?; fi
$ ab -n 1000 http://localhost:3000/stories/9144271.json?expire_comment=9144509 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     67
  66%     68
  75%     69
  80%     70
  90%     72
  95%     73
  98%     75
  99%     76
 100%     79 (longest request)
```

```
$ kill 63398
```
