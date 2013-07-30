sub pre_test
{
	$session->register_master('master_nanecisto.pl'); #Run basic tests

	if($session->run_type eq 'teacher') { # Run all tests
                $session->register_master('master_naostro.pl');
        }
}

sub post_test
{
        my $points = $session->get_points('points'); #Get number of received points
        if ($session->run_type eq 'student') #Basic tests only
        {
                if ($session->has_tag('nanecisto'))
                {
                        $session->add_summary("* test nanecisto neprosel\n"); #The program failed some of the basic tests
                }
                else
                {
                        $session->add_summary("* test nanecisto prosel\n"); #Basic tests ran without any problem
                }
        }
        elsif ($session->run_type eq 'teacher') #All tests
        {

                if (($session->has_tag('naostro')) || ($session->has_tag('nanecisto'))) # Program did not pass all tests, $points points
                {
                  	$session->add_summary("* v testu byla nalezena chyba\n");
                  	$session->add_summary("* pocet bodu za funkcionalitu je: $points\n");
                }
                else # Program passed all tests, 9 points
                {
                    $session->add_summary("* test prosel kompletne spravne\n");
					$session->add_summary("* pocet bodu za funkcionalitu je: 9\n");
                }

                if ($session->has_tag('valgrind')) #Valgrind check
                {
                        $session->add_summary("NEPROSLA kontrola Valgrindem, -1 bod.\n");
                }
                else
                {
                        $session->add_summary("Prosla kontrola Valgrindem.\n");
                }
        }
}
