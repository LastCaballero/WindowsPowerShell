param(
    [switch]$Server,
    [string]$Host = "127.0.0.1",
    [int]$Port = 9000
)

# --- Verbindungsaufbau ---
if ($Server) {
    Write-Host "Starte Server auf Port $Port ..."
    $listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Any, $Port)
    $listener.Start()

    Write-Host "Warte auf Verbindung..."
    $client = $listener.AcceptTcpClient()
    Write-Host "Client verbunden!"

    $stream = $client.GetStream()
}
else {
    Write-Host "Verbinde zu $Host:$Port ..."
    $client = [System.Net.Sockets.TcpClient]::new()
    $client.Connect($Host, $Port)
    Write-Host "Verbunden!"

    $stream = $client.GetStream()
}

# --- Empfangs-ThreadJob ---
$recvJob = Start-ThreadJob -ScriptBlock {
    param($stream)

    $buffer = New-Object byte[] 1024
    while ($true) {
        $bytesRead = $stream.Read($buffer, 0, $buffer.Length)
        if ($bytesRead -le 0) { break }

        $text = [System.Text.Encoding]::UTF8.GetString($buffer, 0, $bytesRead)
        Write-Host "Empfangen: $text"
    }
} -ArgumentList $stream

# --- Senden ---
while ($true) {
    $msg = Read-Host "Nachricht"
    if ($msg -eq "exit") { break }

    $bytes = [System.Text.Encoding]::UTF8.GetBytes($msg)
    $stream.Write($bytes, 0, $bytes.Length)
    $stream.Flush()
}

# --- Aufräumen ---
Write-Host "Beende Verbindung..."

$stream.Close()
$client.Close()

if ($Server) {
    $listener.Stop()
}

Stop-Job $recvJob
Remove-Job $recvJob