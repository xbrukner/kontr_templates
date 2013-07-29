# Set the name of the master test
$master_test->name('master_nanecisto');

# Register unit tests
$master_test->register_unit('unit_diff.pl');
#... other unit tests

# Include additional source files into the compilation process
$master_test->stage_file('BarCode.h'); #Files from _files_
$master_test->stage_compiled_file('BarCode.cpp'); 
$master_test->stage_student_file('BarCodeEAN13.h'); #Files from student
$master_test->stage_compiled_student_file('BarCodeEAN13.cpp');
