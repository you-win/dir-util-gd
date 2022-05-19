extends "res://addons/gut/test.gd"

# https://github.com/bitwes/Gut/wiki/Quick-Start

#-----------------------------------------------------------------------------#
# Builtin functions                                                           #
#-----------------------------------------------------------------------------#

func before_all():
	pass

func before_each():
	pass

func after_each():
	pass

func after_all():
	pass

#-----------------------------------------------------------------------------#
# Utils                                                                       #
#-----------------------------------------------------------------------------#

func assert_eq(a, b, param = "") -> bool:
	.assert_eq(a, b, param)
	return a == b

func assert_true(a, param = "") -> bool:
	.assert_true(a, param)
	return a

func assert_false(a, param = "") -> bool:
	.assert_false(a, param)
	return a

func is_dict_with_size(a, size: int, param = "") -> bool:
	if not assert_eq(typeof(a), TYPE_DICTIONARY, param):
		return false
		
	return assert_eq(a.size(), size, param)

#-----------------------------------------------------------------------------#
# Tests                                                                       #
#-----------------------------------------------------------------------------#

const DirUtil := preload("res://addons/dir_util/dir_util.gd")

const FOLDER_1_EXPECTED := ["folder-1-1", "file_1.txt"]
const FOLDER_1_1_EXPECTED := ["file_1_1.txt"]

const TEMP_DIR := "res://tests/temp"

func test_get_paths_res_path():
	var files = DirUtil.get_files_recursive("res://tests/test_resources/")
	
	if not is_dict_with_size(files, 4):
		return
	
	var folder_4 = files.get("folder 4", {})
	if not is_dict_with_size(folder_4, 1):
		return
	
	if not assert_true(folder_4.has("folder 5")):
		return
	
	var folder_1 = files.get("folder-1", {})
	if not is_dict_with_size(folder_1, 2):
		return
	
	var folder_1_expected := FOLDER_1_EXPECTED.duplicate(true)
	for key in folder_1.keys():
		if key in folder_1_expected:
			folder_1_expected.erase(key)
	
	if not assert_true(folder_1_expected.empty()):
		return
	
	var folder_1_1 = folder_1.get("folder-1-1", {})
	if not is_dict_with_size(folder_1_1, 1):
		return
	
	var folder_1_1_expected := FOLDER_1_1_EXPECTED.duplicate(true)
	for key in folder_1_1.keys():
		if key in folder_1_1_expected:
			folder_1_1_expected.erase(key)
	
	if not assert_true(folder_1_1_expected.empty()):
		return
	
	var file := File.new()
	if file.open(folder_1_1[FOLDER_1_1_EXPECTED.back()], File.READ) != OK:
		assert_true(false)
		return
	
	if not assert_eq(file.get_as_text().strip_edges(), "hello"):
		return

func test_get_paths_absolute_path():
	var files = DirUtil.get_files_recursive(ProjectSettings.globalize_path("res://tests/test_resources/"))
	
	if not is_dict_with_size(files, 4):
		return

func test_get_paths_bad_directory():
	var files = DirUtil.get_files_recursive("asdf")
	
	assert_true(files.empty())

func test_remove_dir():
	var dir := Directory.new()
	
	if not dir.dir_exists(TEMP_DIR):
		assert_false(true)
		return
	
	var inner_dir_name := "%s/inner" % TEMP_DIR
	
	dir.make_dir_recursive("%s/dir" % inner_dir_name)
	dir.make_dir_recursive("%s/dir1" % inner_dir_name)
	
	var files = DirUtil.get_files_recursive(inner_dir_name)
	if not is_dict_with_size(files, 2, "Should be dict of size 2"):
		return
	
	assert_eq(DirUtil.remove_dir_recursive(inner_dir_name), OK, "Should be able to remove %s recursively" % inner_dir_name)

	assert_false(dir.dir_exists(inner_dir_name), "%s should no longer exist" % inner_dir_name)

func test_copy_dir():
	var dir := Directory.new()
	
	if not dir.dir_exists(TEMP_DIR):
		assert_false(true)
		return
	
	var inner_dir_name := "%s/inner" % TEMP_DIR
	var inner_dir_name_copy := "%s/inner_copy" % TEMP_DIR
	
	dir.make_dir_recursive("%s/dir" % inner_dir_name)
	dir.make_dir_recursive("%s/dir1" % inner_dir_name)
	
	var files = DirUtil.get_files_recursive(inner_dir_name)
	if not is_dict_with_size(files, 2, "Should be dict of size 2"):
		return
	
	if not assert_eq(DirUtil.copy_dir_recursive(inner_dir_name, inner_dir_name_copy), OK, "Should be able to copy %s to %s recursively" % [inner_dir_name, inner_dir_name_copy]):
		return
	
	files.clear()
	
	if not assert_true(dir.dir_exists(inner_dir_name), "The original dir should still exist"):
		return
	if not assert_true(dir.dir_exists(inner_dir_name_copy), "The new dir should have been created"):
		return
	
	files = DirUtil.get_files_recursive(inner_dir_name_copy)
	if not is_dict_with_size(files, 2, "The new dir should have 2 entries in it"):
		return
	
	assert_eq(DirUtil.remove_dir_recursive(inner_dir_name), OK, "Should be able to remove %s recursively" % inner_dir_name)
	assert_eq(DirUtil.remove_dir_recursive(inner_dir_name_copy), OK, "Should be able to remove %s recursively" % inner_dir_name_copy)
	
	assert_false(dir.dir_exists(inner_dir_name), "%s should not exist" % inner_dir_name)
	assert_false(dir.dir_exists(inner_dir_name_copy), "%s should not exist" % inner_dir_name_copy)
