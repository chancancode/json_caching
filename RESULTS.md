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
  66%     14
  75%     15
  80%     16
  90%     17
  95%     17
  98%     18
  99%     19
 100%     31 (longest request)
```

### Small article, 2 comments

```
$ ab -n 1000 http://localhost:3000/stories/9146006.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%      6
  66%      6
  75%      6
  80%      7
  90%      8
  95%      8
  98%      8
  99%      9
 100%     11 (longest request)
```

### Medium article, 141 comments

```
$ ab -n 1000 http://localhost:3000/stories/9145007.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     50
  66%     52
  75%     53
  80%     54
  90%     54
  95%     56
  98%     57
  99%     59
 100%     63 (longest request)
```

### Long article, 121 comments

```
$ ab -n 1000 http://localhost:3000/stories/9145126.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     45
  66%     47
  75%     48
  80%     49
  90%     49
  95%     50
  98%     52
  99%     53
 100%     56 (longest request)
```

### No article, 136 comments

```
$ ab -n 1000 http://localhost:3000/stories/9144271.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     49
  66%     51
  75%     52
  80%     53
  90%     53
  95%     55
  98%     57
  99%     59
 100%     71 (longest request)
```

```
$ kill 85565
```

## 100% MISS (Caching Encoder + Null Store)

```
$ RAILS_ENV=production CACHE=1 NULL_STORE=1 rails server --daemon 1> /dev/null
```

### Index

```
$ ab -n 1000 http://localhost:3000/stories.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     21
  66%     23
  75%     24
  80%     24
  90%     24
  95%     26
  98%     27
  99%     28
 100%     36 (longest request)
```

### Small article, 2 comments

```
$ ab -n 1000 http://localhost:3000/stories/9146006.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%      7
  66%      8
  75%      8
  80%      9
  90%      9
  95%     10
  98%     10
  99%     10
 100%     13 (longest request)
```

### Medium article, 141 comments

```
$ ab -n 1000 http://localhost:3000/stories/9145007.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     77
  66%     79
  75%     80
  80%     80
  90%     82
  95%     84
  98%     85
  99%     86
 100%     90 (longest request)
```

### Long article, 121 comments

```
$ ab -n 1000 http://localhost:3000/stories/9145126.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     69
  66%     70
  75%     71
  80%     72
  90%     73
  95%     75
  98%     76
  99%     77
 100%     81 (longest request)
```

### No article, 136 comments

```
$ ab -n 1000 http://localhost:3000/stories/9144271.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     75
  66%     77
  75%     78
  80%     78
  90%     79
  95%     81
  98%     83
  99%     85
 100%     90 (longest request)
```

```
$ kill 85605
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
 100%     15 (longest request)
```

### Small article, 2 comments

```
$ ab -n 1000 http://localhost:3000/stories/9146006.json | tail -n 11

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
 100%     38 (longest request)
```

### Long article, 121 comments

```
$ ab -n 1000 http://localhost:3000/stories/9145126.json | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%      4
  66%      4
  75%      5
  80%      5
  90%      6
  95%      6
  98%      7
  99%      7
 100%      9 (longest request)
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
  95%      6
  98%      6
  99%      7
 100%      9 (longest request)
```

```
$ kill 85650
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
  98%     24
  99%     26
 100%     34 (longest request)
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
  99%     16
 100%     23 (longest request)
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
 100%     18 (longest request)
```

### Small article, 2 comments (expire article)

```
$ ab -n 1000 http://localhost:3000/stories/9146006.json?expire_article=18 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%      9
  66%      9
  75%     10
  80%     10
  90%     11
  95%     11
  98%     12
  99%     14
 100%     17 (longest request)
```

### Medium article, 141 comments (expire story)

```
$ ab -n 1000 http://localhost:3000/stories/9145007.json?expire_story=9145007 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     55
  66%     57
  75%     57
  80%     58
  90%     59
  95%     61
  98%     63
  99%     63
 100%     78 (longest request)
```

### Medium article, 141 comments (expire comment)

```
$ ab -n 1000 http://localhost:3000/stories/9145007.json?expire_comment=9145058 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     56
  66%     58
  75%     59
  80%     59
  90%     61
  95%     63
  98%     64
  99%     65
 100%     69 (longest request)
```

### Medium article, 141 comments (expire article)

```
$ ab -n 1000 http://localhost:3000/stories/9145007.json?expire_article=8 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     55
  66%     56
  75%     57
  80%     58
  90%     59
  95%     61
  98%     63
  99%     64
 100%     69 (longest request)
```

### Long article, 121 comments (expire story)

```
$ ab -n 1000 http://localhost:3000/stories/9145126.json?expire_story=9145126 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     49
  66%     51
  75%     52
  80%     53
  90%     54
  95%     56
  98%     57
  99%     58
 100%     63 (longest request)
```

### Long article, 121 comments (expire comment)

```
$ ab -n 1000 http://localhost:3000/stories/9145126.json?expire_comment=9145650 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     51
  66%     53
  75%     54
  80%     54
  90%     55
  95%     57
  98%     59
  99%     61
 100%     64 (longest request)
```

### Long article, 121 comments (expire article)

```
$ ab -n 1000 http://localhost:3000/stories/9145126.json?expire_article=9 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     49
  66%     51
  75%     52
  80%     53
  90%     54
  95%     55
  98%     58
  99%     58
 100%     61 (longest request)
```

### No article, 136 comments (expire story)

```
$ ab -n 1000 http://localhost:3000/stories/9144271.json?expire_story=9144271 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     53
  66%     55
  75%     56
  80%     57
  90%     58
  95%     60
  98%     62
  99%     63
 100%     67 (longest request)
```

### No article, 136 comments (expire comment)

```
$ ab -n 1000 http://localhost:3000/stories/9144271.json?expire_comment=9144509 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     55
  66%     57
  75%     58
  80%     58
  90%     60
  95%     61
  98%     63
  99%     63
 100%     69 (longest request)
```

```
$ kill 85680
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
 100%     25 (longest request)
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
  98%     12
  99%     14
 100%     31 (longest request)
```

### Small article, 2 comments (expire comment)

```
$ ab -n 1000 http://localhost:3000/stories/9146006.json?expire_comment=9147664 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     11
  66%     12
  75%     12
  80%     13
  90%     14
  95%     14
  98%     15
  99%     18
 100%     22 (longest request)
```

### Small article, 2 comments (expire article)

```
$ ab -n 1000 http://localhost:3000/stories/9146006.json?expire_article=18 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%      9
  66%      9
  75%     10
  80%     10
  90%     11
  95%     11
  98%     12
  99%     16
 100%     18 (longest request)
```

### Medium article, 141 comments (expire story)

```
$ ab -n 1000 http://localhost:3000/stories/9145007.json?expire_story=9145007 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     43
  66%     44
  75%     45
  80%     46
  90%     47
  95%     48
  98%     51
  99%     53
 100%    121 (longest request)
```

### Medium article, 141 comments (expire comment)

```
$ ab -n 1000 http://localhost:3000/stories/9145007.json?expire_comment=9145058 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     44
  66%     46
  75%     47
  80%     47
  90%     49
  95%     49
  98%     52
  99%     54
 100%     62 (longest request)
```

### Medium article, 141 comments (expire article)

```
$ ab -n 1000 http://localhost:3000/stories/9145007.json?expire_article=8 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     42
  66%     44
  75%     45
  80%     45
  90%     46
  95%     47
  98%     50
  99%     52
 100%     65 (longest request)
```

### Long article, 121 comments (expire story)

```
$ ab -n 1000 http://localhost:3000/stories/9145126.json?expire_story=9145126 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     37
  66%     40
  75%     40
  80%     40
  90%     42
  95%     42
  98%     45
  99%     46
 100%     50 (longest request)
```

### Long article, 121 comments (expire comment)

```
$ ab -n 1000 http://localhost:3000/stories/9145126.json?expire_comment=9145650 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     39
  66%     41
  75%     42
  80%     42
  90%     44
  95%     45
  98%     47
  99%     48
 100%     52 (longest request)
```

### Long article, 121 comments (expire article)

```
$ ab -n 1000 http://localhost:3000/stories/9145126.json?expire_article=9 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     38
  66%     39
  75%     40
  80%     41
  90%     42
  95%     43
  98%     46
  99%     47
 100%     50 (longest request)
```

### No article, 136 comments (expire story)

```
$ ab -n 1000 http://localhost:3000/stories/9144271.json?expire_story=9144271 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     40
  66%     43
  75%     43
  80%     43
  90%     45
  95%     46
  98%     48
  99%     48
 100%     50 (longest request)
```

### No article, 136 comments (expire comment)

```
$ ab -n 1000 http://localhost:3000/stories/9144271.json?expire_comment=9144509 | tail -n 11

Percentage of the requests served within a certain time (ms)
  50%     42
  66%     45
  75%     45
  80%     46
  90%     47
  95%     48
  98%     51
  99%     52
 100%     56 (longest request)
```

```
$ kill 85775
```
