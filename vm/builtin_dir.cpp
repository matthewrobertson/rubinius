#include "builtin.hpp"
#include "builtin_dir.hpp"
#include "ffi.hpp"

#include <sys/types.h>
#include <dirent.h>

namespace rubinius {
  Dir* Dir::create(STATE) {
    Dir* d = (Dir*)state->om->new_object(G(dir), Dir::fields);
    SET(d, data, Qnil);

    return d;
  }

  void Dir::guard(STATE) {
    // TODO: raise IOError, "closed directory"
    if(data->nil_p()) {
      throw std::runtime_error("dir->data is nil");
    }
  }

  OBJECT Dir::open(STATE, String* path) {
    DIR* d = opendir(path->byte_address(state));

    if(!d) state->raise_from_errno("Unable to open directory");
    SET(this, data, MemoryPointer::create(state, d));

    return Qnil;
  }

  OBJECT Dir::close(STATE) {
    guard(state);

    DIR* d = (DIR*)data->pointer;
    if(d) {
      SET(this, data, Qnil);
      closedir(d);
      return Qtrue;
    }

    return Qfalse;
  }

  OBJECT Dir::closed_p(STATE) {
    return data->nil_p() ? Qtrue : Qfalse;
  }

  OBJECT Dir::read(STATE) {
    guard(state);

    DIR* d = (DIR*)data->pointer;
    struct dirent *ent = readdir(d);

    if(!ent) return Qnil;

    return String::create(state, ent->d_name);
  }

  OBJECT Dir::control(STATE, FIXNUM kind, INTEGER pos) {
    guard(state);

    DIR* d = (DIR*)data->pointer;

    switch(kind->n2i()) {
    case 0:
      seekdir(d, pos->n2i());
      return Qtrue;
    case 1:
      rewinddir(d);
      return Qtrue;
    case 2:
      return Object::i2n(state, telldir(d));
    }
    return Qnil;
  }
}
