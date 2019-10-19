import ballerina/cache;
import ballerina/io;
import ballerina/time;
import ballerina/math;

// import ballerina/runtime;

public function evaluate(int cacheSize) {
  cache:Cache cache =  new(3600000, cacheSize, 0.25);

  int startTime = time:currentTime().time;

  int q = 1000000;
  int i = 0;
  int sum = 0;
  while (i < q) {
    string key = i.toString();
    cache.put(key, i);
    int getIndex = i - <int>math:randomInRange(0, cacheSize);
    if (getIndex < 0) {
      getIndex = 0;
    }
    string getKey = getIndex.toString();
    any? getValue = cache.get(getKey);
    if (getValue is int) {
      sum += <int>getValue;
    }
    i += 1;
  }
  int endTime = time:currentTime().time;

  io:println("Cache size: ", cacheSize, " sum: ", sum, " time: ", endTime-startTime);

  // expected time 
  map<int> fastCache = {};

  startTime = time:currentTime().time;
  i = 0;
  sum = 0;
  while (i < q) {
    string key = i.toString();
    fastCache[key] = i;
    int getIndex = i - <int>math:randomInRange(0, cacheSize);
    if (getIndex < 0) {
      getIndex = 0;
    }
    string getKey = getIndex.toString();
    int? getValue = fastCache.get(getKey);
    if (getValue is int) {
      sum += getValue;
    }
    i += 1;
  }
  endTime = time:currentTime().time;

  io:println("Cache size: ", cacheSize, " sum: ", sum, " expected time: ", endTime-startTime);

}

public function main() {
  evaluate(5);
  evaluate(10);
  evaluate(20);
  evaluate(40);
  evaluate(80);
  evaluate(160);
  evaluate(320);
  evaluate(640);
  evaluate(1000);
}