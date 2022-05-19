# Dir Util GD

[![Chat on Discord](https://img.shields.io/discord/853476898071117865?label=chat&logo=discord)](https://discord.gg/6mcdWWBkrr)
[![package](https://img.shields.io/badge/package-1.0.0-blue)](https://www.npmjs.com/package/@sometimes_youwin/dir_util)

Directory utils for Godot 3.x.

Includes functions for:
* Recursively listing the contents of a directory
* Recursively removing a directory
* Recursively copying a directory

## Examples

Given a directory located at `res://my_dir` like
```
my_dir
- dir1
  - file1
  - file2
- dir2
```

And `dir_util.gd` loaded like
```GDScript
const DirUtil = preload("res://addons/dir_util/dir_util.gd")
```

### Listing the contents of a directory

Returns a `Dictionary` of the directory's contents. An empty `Dictionary` will be returned
if the directory does not exist.

```GDScript
var files: Dictionary = DirUtil.get_files_recursive("res://my_dir")

print(files.size()) # prints "2"
print(files.dir1.size()) # prints "2"
print(files.dir2.size()) # prints "0"
```

Expected contents of `files`
```JSON
{
    "dir1": {
        "file1": "res://my_dir/dir1/file1",
        "file2": "res://my_dir/dir1/file2",
    },
    "dir2": {}
}
```

### Recursively copying a directory

Returns `OK` or an error code.

```GDScript
assert(DirUtils.copy_dir_recursive("res://my_dir", "res://some_other_dir"), OK)
```

### Recursively delete a directory

Returns `OK` or an error code.

```GDScript
assert(DirUtils.remove_dir_recursive("res://my_dir"), OK)
```
