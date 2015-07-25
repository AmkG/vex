
using VEX;

const int NUMBER = 42;

int
main() {

  var m = new EntityManager();

  stdout.printf("Creating entities:");
  for (var i = 0; i < NUMBER; ++i) {
    var e = m.create();
    stdout.printf(" %d", e.id);
  }
  stdout.printf("\n");

  stdout.printf("Traversing entities:");
  int count = 0;
  foreach (Entity e in m) {
    ++count;
    stdout.printf(" %d", e.id);
  }
  stdout.printf("\n");

  stdout.printf("Entities traversed: %d\n", count);

  if (count == NUMBER) {
    /* Pass.  */
    return 0;
  } else {
    /* Fail.  */
    return 1;
  }
}

