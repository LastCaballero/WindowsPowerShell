function Pager {
	param (
		[string[]]$Files
	)
	begin {
		$Lines = [System.Collections.ArrayList]::new()
		$LinesToDisplay = [System.Console]::WindowHeight - 2
		$LineStart = 0
	}

	process {
		$Lines.Add( $_ )
	}

	end {
		$Files | Foreach-Object { $Lines.Add( ( Get-Content $_ ) ) }
		$i = 0
		$exit = $false
		for ( $i -le $Lines.Count ) {
			Clear-Host
			"`n"
			$Lines[ $i .. ( $i + $LinesToDisplay ) ]
			"space , (b)ack, uparrow, downarrow, (e)xit"
			$key = [System.Console]::ReadKey()
			switch ( $key.Key ) {
				{ $_ -eq "Spacebar" }{ 
					$i += $LinesToDisplay
				}
				{ $_ -eq "b" }{ 
					$i -= $LinesToDisplay
				}
				{ $_ -eq "UpArrow" }{
					$i -= 1
				}
				{$_ -eq "DownArrow"}{
					$i += 1
				}
				{$_ -eq "e"}{
					$exit = $true ; break ;
				}
			}
			if ( $exit ) { break }
			
			
		}
		
	}
}
