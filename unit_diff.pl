# Name the unit test
$unit_test->name('unit_diff.pl');
my $input_file = 'input';
my $expected_file = 'expected_output';
my $fail_tag = "nanecisto"; #Or "naostro"
my $detailed_output = "teacher"; #In case of all tests, this should be "both"
if($session->run_type eq 'teacher') { #This may be ommited for "naostro"
        $detailed_output = "both";
}
my $detailed_info = "Studentsky main, diff stdout, vstupni soubor $input_file, ocekavany vystup $expected_file";

#Stage student main - if this is common for all the unit tests in master tests, this line should be in master test
$unit_test->stage_compiled_student_file('main.cpp');

$unit_test->stage_file($input_file);
$unit_test->stage_file($expected_file);

$unit_test->log("[TEST] Test pomoci studentskeho mainu a diffu");

$unit_test->compile();

# In case the compilation failed, end the test
if ($unit_test->compilation->result ne 'clean') 
{ 
	$unit_test->log_tag("compilation", "[FAIL] Program se nepodarilo zkompilovat");
	$unit_test->add_tag($fail_tag);
	return; 
}

# Otherwise continue and run the application
$unit_test->run($input_file);
#OR with Valgrind:
#$unit_test->run_grind('input_data');

if(not $unit_test->execution->success)
{ 
	$unit_test->log_run_fail("[FAIL]");
	$unit_test->log($detailed_info, $detailed_output);
	$unit_test->add_tag($fail_tag, "execution");
	return; 
}
elsif ($unit_test->execution->exit_value != 0)
{
	$unit_test->log_tag("exit_value", "[FAIL] Testovaci program skoncil s nenulovou navratovou hodnotou.");
	$unit_test->log($detailed_info, $detailed_output);
	$unit_test->add_tag($fail_tag);
	return;
}

# Compare the ouput to the expected output file
$unit_test->diff_stdout('normal', $expected_file);
if($unit_test->difference->exit_value != 0)
{
	# Output info and send log to the teacher in case of failure
	$unit_test->log_tag("diff_output", "[FAIL] Vystup testovaciho vstupu se neshoduje s ocekavanym vysledkem.");
	$unit_test->log($detailed_info, $detailed_output);
	$unit_test->add_tag($fail_tag);
	$unit_test->difference->log_stdout("teacher");
	return;
}

#In case of Valgrind:
#if ($unit_test->valgrind->grind_errors) {
#        $unit_test->log_tag("valgrind", "[VALGRIND] Chyba pri kontrole Valgrindem:");
#        my $grinduser = $unit_test->valgrind->grind_user;
#        my $grinduserc = `cat $grinduser`;
#        my $grindall = $unit_test->valgrind->grind_path;
#        my $grindallc = `cat $grindall`;
#        $unit_test->log($grinduserc);
#        $unit_test->log($grindallc, 'teacher');
#}

# Output info in case of success
$unit_test->log_tag("ok", "[OK] Vystup testovaciho vstupu se shoduje s ocekavanym vysledkem.");
$unit_test->
