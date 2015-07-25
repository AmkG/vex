
using VEX;

const int NUMBER = 42;

int
main() {
  var manager = new EntityManager();

  stdout.printf("Creating then destroying an entity.\n");
  var entity = manager.create();
  stdout.printf("ID: %d\n", entity.id);
  entity.destroy();
  if (entity.is_live()) {
    stdout.printf("** Expecting dead entity!\n");
    return 1;
  }

  stdout.printf("Iterating over entities in (supposedly empty) manager.\n");
  int count = 0;
  foreach (Entity e in manager) {
    ++count;
  }
  if (count != 0) {
    stdout.printf("** Expected empty manager! %0d entities.\n", count);
    return 1;
  }

  stdout.printf("Creating multiple entities: ");
  for (int i = 0; i < NUMBER; ++i) {
    var new_entity = manager.create();
    stdout.printf(" %d", new_entity.id);
    if (new_entity.id == entity.id) {
      stdout.printf("** Expected entity ID is not reused!\n");
      return 1;
    }
  }
  stdout.printf("\n");
  entity = null;

  stdout.printf("OK\n");
  return 0;
}
