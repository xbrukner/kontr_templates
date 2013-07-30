$unit_test->name('unit_series.pl');

my $fail_tag = "nanecisto"; #Or "naostro"
my $detailed_output = "teacher"; #In case of all tests, this should be "both"
if($session->run_type eq 'teacher') { #This may be ommited for "naostro"
        $detailed_output = "both";
}
my $detailed_info = ""; #Will be set for every input

$unit_test->stage_file('vstup_korektny_1.csv');
$unit_test->stage_file('vstup_korektny_2.csv');
$unit_test->stage_file('vstup_korektny_3.csv');
$unit_test->stage_file('vstup_korektny_4.csv');
$unit_test->stage_file('vstup_korektny_5.csv');
$unit_test->stage_file('vstup_korektny_6.csv');

$unit_test->stage_student_file('sitemap.h');
$unit_test->stage_compiled_student_file('main.c');
$unit_test->stage_compiled_student_file('sitemap.c');

# compile
$unit_test->compile();
if ($unit_test->compilation->result ne 'clean') 
{ 
	$unit_test->log_tag("compilation", "[FAIL] Program se nepodarilo zkompilovat");
	$unit_test->add_tag($fail_tag);
	return; 
}

for my $i (1 .. 6){
	$detailed_info = "Studentsky main, vstupni soubor vstup_korektny_$i.csv, generovani SVG";
	$unit_test->subtest("vstup_$i");
	$unit_test->log("[TEST]\tKorektni vstup $i");
	$unit_test->run_grind("vstup_korektny_$i.csv", "output_$i.svg");
	if(not $unit_test->execution->success)
	{ 
		$unit_test->log_run_fail("[FAIL]");
		$unit_test->log($detailed_info, $detailed_output);
		$unit_test->add_tag($fail_tag, "execution");
		return; #If you want to run all tests, replace with next;
	}
	elsif ($unit_test->execution->exit_value != 0)
	{
		$unit_test->log_tag("exit_value", "[FAIL] Testovaci program skoncil s nenulovou navratovou hodnotou.");
		$unit_test->log($detailed_info, $detailed_output);
		$unit_test->add_tag($fail_tag);
		return; #If you want to run all tests, replace with next;
	}
	if ($unit_test->valgrind->grind_errors)
	{
		$unit_test->log_tag('valgrind', "[VALGRIND] Chyba pri kontrole Valgrindem:");
		my $grinduser = $unit_test->valgrind->grind_user;
		my $grinduserc = `cat $grinduser`;
		my $grindall = $unit_test->valgrind->grind_path;
		my $grindallc = `cat $grindall`;
		$unit_test->log($grinduserc);
		$unit_test->log($grindallc, 'teacher');
	}
	$unit_test->add_attachment("output_$i.svg", "teacher");
	$unit_test->log("Porovnejte prilohu output_$i.svg se http://fi.muni.cz/~xbrukner/p12_pb071_vystupy/output_$i.svg a udelte az jeden dalsi bod, pokud se dle zadani shoduje.", "teacher");
	$unit_test->log_tag("ok", "[OK] Test uspesne prosel");
	$unit_test->add_points('points' => 0.1);
}

$unit_test->log("[OK] Test korektnich vstupu prosel.\n");

