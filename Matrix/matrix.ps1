param (
	[ValidateSet("Black", "Cyan", "DarkCyan", "DarkGreen", "DarkRed", "Gray", "Magenta", "White",
"Blue", "DarkBlue", "DarkGray", "DarkMagenta", "DarkYellow", "Green", "Red", "Yellow")]
	[string]$Color
)

$Colors = "Black", "Cyan", "DarkCyan", "DarkGreen", "DarkRed", "Gray", "Magenta", "White",
"Blue", "DarkBlue", "DarkGray", "DarkMagenta", "DarkYellow", "Green", "Red", "Yellow"

function Random-Char {
	"0123456789abcdef".ToCharArray() | Get-Random
}


function Line {
	while ( $i -le $Width ) {
		$Width 	=[System.Console]::WindowWidth
		$Exp 	= " $( Random-Char )$( Random-Char )"
		$RandomColor = $Colors | Get-Random
		$Exp.ToCharArray().ForEach{	
			Write-Host -ForegroundColor $( if( $Color ) { $Color } else { $RandomColor } ) -NoNewline $_
			$i++
			if ( $i -ge $Width ) {
				break
			}	
		}
	}
}

while ( 1 ) {
	Line
}
