# Name the unit test
$unit_test->name('unit_bonus_files_test.pl');

$unit_test->log("[BONUS] Test existence bonusovych souboru.");

#Test existence souboru main_bonus.c, diffman_bonus.c a diffman_bonus.h
#Nasledna detekce v unit testu je na zacatku unit testu pomoci
#if ($session->has_tag('bonus_files') { return; }

if (($session->available_file(sub { /main_bonus\.c/ } )) and ($session->available_file(sub { /diffman_bonus\.c/ } )) and ($session->available_file(sub { /diffman_bonus\.h/ } ))) 
{ 
	$unit_test->log_tag('ok',"[OK] Soubory nalezeny.");
}
else
{
	$unit_test->log_tag('bonus_files',"[FAIL] Jeden nebo vice souboru chybi.");
}
