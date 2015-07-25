
using VEX;

int
main() {
  var m = new EntityManager();

  var e = m.create();

  assert (e.id == 0);
  return 0;
}
