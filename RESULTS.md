```
$ RAILS_ENV=production rake db:drop db:create db:migrate db:seed 1> /dev/null
```


# Basic Tests

## Baseline (JSON Gem Encoder)

```
$ RAILS_ENV=production  rails server --daemon 1> /dev/null
```

### Index

```
$ ab -n 1000 http://localhost:3000/stories.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     14
  66%     15
  75%     16
  80%     16
  90%     17
  95%     18
  98%     19
  99%     20
 100%     24 (longest request)
```

### Small article, 2 comments

```
$ ab -n 1000 http://localhost:3000/stories/9146006.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%      6
  66%      7
  75%      7
  80%      7
  90%      8
  95%      8
  98%      9
  99%      9
 100%     12 (longest request)
```

### Medium article, 141 comments

```
$ ab -n 1000 http://localhost:3000/stories/9145007.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     52
  66%     54
  75%     55
  80%     55
  90%     56
  95%     58
  98%     60
  99%     61
 100%     63 (longest request)
```

### Long article, 121 comments

```
$ ab -n 1000 http://localhost:3000/stories/9145126.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     47
  66%     49
  75%     50
  80%     50
  90%     51
  95%     52
  98%     54
  99%     55
 100%     62 (longest request)
```

### No article, 136 comments

```
$ ab -n 1000 http://localhost:3000/stories/9144271.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     52
  66%     54
  75%     54
  80%     54
  90%     56
  95%     58
  98%     59
  99%     60
 100%     68 (longest request)
```

```
$ kill 50734
```

## 100% MISS (Caching Encoder + Null Store)

```
$ RAILS_ENV=production CACHE=1 NULL_STORE=1 rails server --daemon 1> /dev/null
```

### Index

```
$ ab -n 1000 http://localhost:3000/stories.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     19
  66%     21
  75%     21
  80%     22
  90%     22
  95%     23
  98%     24
  99%     25
 100%     33 (longest request)
```

### Small article, 2 comments

```
$ ab -n 1000 http://localhost:3000/stories/9146006.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%      7
  66%      7
  75%      8
  80%      8
  90%      9
  95%      9
  98%     10
  99%     10
 100%     13 (longest request)
```

### Medium article, 141 comments

```
$ ab -n 1000 http://localhost:3000/stories/9145007.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     71
  66%     73
  75%     73
  80%     74
  90%     75
  95%     77
  98%     79
  99%     80
 100%     85 (longest request)
```

### Long article, 121 comments

```
$ ab -n 1000 http://localhost:3000/stories/9145126.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     62
  66%     64
  75%     64
  80%     65
  90%     66
  95%     68
  98%     70
  99%     71
 100%     75 (longest request)
```

### No article, 136 comments

```
$ ab -n 1000 http://localhost:3000/stories/9144271.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     68
  66%     70
  75%     70
  80%     71
  90%     72
  95%     74
  98%     75
  99%     76
 100%     83 (longest request)
```

```
$ kill 50774
```

## 100% HIT (Caching Encoder + Memory Store)

```
$ RAILS_ENV=production CACHE=1 rails server --daemon 1> /dev/null
```

### Index

```
$ ab -n 1000 http://localhost:3000/stories.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%      8
  66%      9
  75%      9
  80%     10
  90%     11
  95%     11
  98%     12
  99%     12
 100%     22 (longest request)
```

### Small article, 2 comments

```
$ ab -n 1000 http://localhost:3000/stories/9146006.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%      4
  66%      4
  75%      4
  80%      4
  90%      5
  95%      6
  98%      6
  99%      7
 100%      8 (longest request)
```

### Medium article, 141 comments

```
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
 100%     42 (longest request)
```

### Long article, 121 comments

```
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
 100%     36 (longest request)
```

### No article, 136 comments

```
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
 100%      8 (longest request)
```

```
$ kill 50822
```


# Cache Reuse (Russian-doll)

## Baseline (JSON Gem Encoder)

```
$ RAILS_ENV=production  rails server --daemon 1> /dev/null
```

### Index

```
$ ab -n 1000 http://localhost:3000/stories.json?expire_story=9144271 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     17
  66%     19
  75%     20
  80%     20
  90%     21
  95%     22
  98%     23
  99%     24
 100%     36 (longest request)
```

### Small article, 2 comments (expire story)

```
$ ab -n 1000 http://localhost:3000/stories/9146006.json?expire_story=9146006 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%      9
  66%     10
  75%     10
  80%     11
  90%     11
  95%     12
  98%     13
  99%     13
 100%     20 (longest request)
```

### Small article, 2 comments (expire comment)

```
$ ab -n 1000 http://localhost:3000/stories/9146006.json?expire_comment=9147664 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     10
  66%     11
  75%     12
  80%     12
  90%     13
  95%     13
  98%     14
  99%     15
 100%     35 (longest request)
```

### Small article, 2 comments (expire article)

```
$ ab -n 1000 http://localhost:3000/stories/9146006.json?expire_article=18 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%      9
  66%     10
  75%     10
  80%     10
  90%     11
  95%     12
  98%     12
  99%     15
 100%     19 (longest request)
```

### Medium article, 141 comments (expire story)

```
$ ab -n 1000 http://localhost:3000/stories/9145007.json?expire_story=9145007 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     56
  66%     57
  75%     58
  80%     58
  90%     60
  95%     62
  98%     64
  99%     65
 100%    115 (longest request)
```

### Medium article, 141 comments (expire comment)

```
$ ab -n 1000 http://localhost:3000/stories/9145007.json?expire_comment=9145058 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     58
  66%     60
  75%     60
  80%     61
  90%     63
  95%     64
  98%     66
  99%     68
 100%     71 (longest request)
```

### Medium article, 141 comments (expire article)

```
$ ab -n 1000 http://localhost:3000/stories/9145007.json?expire_article=8 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     56
  66%     58
  75%     58
  80%     59
  90%     61
  95%     62
  98%     64
  99%     64
 100%     69 (longest request)
```

### Long article, 121 comments (expire story)

```
$ ab -n 1000 http://localhost:3000/stories/9145126.json?expire_story=9145126 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     51
  66%     52
  75%     53
  80%     53
  90%     54
  95%     57
  98%     58
  99%     59
 100%     65 (longest request)
```

### Long article, 121 comments (expire comment)

```
$ ab -n 1000 http://localhost:3000/stories/9145126.json?expire_comment=9145650 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     53
  66%     54
  75%     54
  80%     55
  90%     56
  95%     58
  98%     60
  99%     61
 100%     66 (longest request)
```

### Long article, 121 comments (expire article)

```
$ ab -n 1000 http://localhost:3000/stories/9145126.json?expire_article=9 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     50
  66%     52
  75%     53
  80%     53
  90%     54
  95%     56
  98%     58
  99%     59
 100%     64 (longest request)
```

### No article, 136 comments (expire story)

```
$ ab -n 1000 http://localhost:3000/stories/9144271.json?expire_story=9144271 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     55
  66%     56
  75%     57
  80%     57
  90%     58
  95%     61
  98%     62
  99%     63
 100%     86 (longest request)
```

### No article, 136 comments (expire comment)

```
$ ab -n 1000 http://localhost:3000/stories/9144271.json?expire_comment=9144509 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     57
  66%     58
  75%     59
  80%     59
  90%     61
  95%     63
  98%     64
  99%     66
 100%     80 (longest request)
```

```
$ kill 50850
```

## Caching Encoder

```
$ RAILS_ENV=production CACHE=1 rails server --daemon 1> /dev/null
```

### Index

```
$ ab -n 1000 http://localhost:3000/stories.json?expire_story=9144271 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     15
  66%     16
  75%     18
  80%     18
  90%     19
  95%     20
  98%     20
  99%     21
 100%     23 (longest request)
```

### Small article, 2 comments (expire story)

```
$ ab -n 1000 http://localhost:3000/stories/9146006.json?expire_story=9146006 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%      9
  66%     10
  75%     10
  80%     10
  90%     11
  95%     12
  98%     13
  99%     14
 100%     31 (longest request)
```

### Small article, 2 comments (expire comment)

```
$ ab -n 1000 http://localhost:3000/stories/9146006.json?expire_comment=9147664 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     11
  66%     11
  75%     12
  80%     12
  90%     13
  95%     14
  98%     15
  99%     17
 100%     21 (longest request)
```

### Small article, 2 comments (expire article)

```
$ ab -n 1000 http://localhost:3000/stories/9146006.json?expire_article=18 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%      9
  66%     10
  75%     10
  80%     11
  90%     11
  95%     12
  98%     12
  99%     16
 100%     19 (longest request)
```

### Medium article, 141 comments (expire story)

```
$ ab -n 1000 http://localhost:3000/stories/9145007.json?expire_story=9145007 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     44
  66%     45
  75%     46
  80%     47
  90%     48
  95%     50
  98%     52
  99%     53
 100%    127 (longest request)
```

### Medium article, 141 comments (expire comment)

```
$ ab -n 1000 http://localhost:3000/stories/9145007.json?expire_comment=9145058 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     46
  66%     47
  75%     47
  80%     48
  90%     49
  95%     50
  98%     53
  99%     54
 100%    613 (longest request)
```

### Medium article, 141 comments (expire article)

```
$ ab -n 1000 http://localhost:3000/stories/9145007.json?expire_article=8 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     44
  66%     45
  75%     46
  80%     46
  90%     47
  95%     49
  98%     52
  99%     53
 100%     59 (longest request)
```

### Long article, 121 comments (expire story)

```
$ ab -n 1000 http://localhost:3000/stories/9145126.json?expire_story=9145126 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     39
  66%     41
  75%     41
  80%     42
  90%     42
  95%     43
  98%     45
  99%     47
 100%     52 (longest request)
```

### Long article, 121 comments (expire comment)

```
$ ab -n 1000 http://localhost:3000/stories/9145126.json?expire_comment=9145650 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     42
  66%     43
  75%     43
  80%     43
  90%     45
  95%     46
  98%     48
  99%     49
 100%     55 (longest request)
```

### Long article, 121 comments (expire article)

```
$ ab -n 1000 http://localhost:3000/stories/9145126.json?expire_article=9 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     39
  66%     41
  75%     41
  80%     42
  90%     43
  95%     44
  98%     47
  99%     48
 100%     54 (longest request)
```

### No article, 136 comments (expire story)

```
$ ab -n 1000 http://localhost:3000/stories/9144271.json?expire_story=9144271 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     42
  66%     44
  75%     44
  80%     45
  90%     46
  95%     47
  98%     49
  99%     51
 100%    101 (longest request)
```

### No article, 136 comments (expire comment)

```
$ ab -n 1000 http://localhost:3000/stories/9144271.json?expire_comment=9144509 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     44
  66%     45
  75%     46
  80%     47
  90%     49
  95%     51
  98%     53
  99%     57
 100%     71 (longest request)
```

```
$ kill 51007
```
