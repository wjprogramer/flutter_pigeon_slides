#include <stdint.h>
#include <time.h>

static int64_t counter_value = 0;
static int64_t counter_updated_at = 0;

static int64_t now_ms(void) {
  struct timespec ts;
  clock_gettime(CLOCK_REALTIME, &ts);
  return (int64_t)ts.tv_sec * 1000 + (int64_t)(ts.tv_nsec / 1000000);
}

int64_t get_counter(void) { return counter_value; }

int64_t add_counter(int64_t delta) {
  counter_value += delta;
  counter_updated_at = now_ms();
  return counter_value;
}

int64_t reset_counter(void) {
  counter_value = 0;
  counter_updated_at = now_ms();
  return counter_value;
}

int64_t get_counter_updated_at(void) { return counter_updated_at; }

