const keys = require('./keys');
const redis = require('redis');

const redisClient = redis.createClient({
  host: keys.redisHost,
  port: keys.redisPort,
  retry_strategy: () => 1000
});
const sub = redisClient.duplicate();
console.log('Redis Host:'+keys.redisHost);

function fib(index) {
  if (index < 2) return 1;
  return fib(index - 1) + fib(index - 2);
}

sub.on('connect', function () {
  console.log('worker connected to redis');
})

sub.on('message', (channel, message) => {
  redisClient.hset('values', message, fib(parseInt(message)));
  console.log('values sent from worker');
});
sub.subscribe('insert');