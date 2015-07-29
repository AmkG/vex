
namespace VEX.TP {

private static
Once< ThreadPool<SubsystemTaskWrapper> > singleton;

private static
unowned ThreadPool<SubsystemTaskWrapper>
get() {
  return singleton.once(() => {

    ThreadPool<SubsystemTaskWrapper>? rv = null;

    try {
      rv = new ThreadPool<SubsystemTaskWrapper>.with_owned_data
        ( /*func*/          process1
        , /*max_threads*/   (int) get_num_processors()
        , /*exclusive*/     false
        );
    } catch (ThreadError ignored) { }

    return (!) (owned) rv;

  });
}

private static
void
process1 (owned SubsystemTaskWrapper wrapper) {
  var task = (owned) wrapper.task;
  wrapper = null;
  task();
}

/* Library access.  */
internal static
void
add(owned SubsystemTask task) {
  try {
    get().add(new SubsystemTaskWrapper((owned) task));
  } catch (ThreadError ignored) { }
}

}
