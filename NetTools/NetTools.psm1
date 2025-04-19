class WebServer {
	[System.Net.Sockets.TcpListener]$Server
	[System.Net.Sockets.Socket]$ClientSocket
	[string]$Address
	[string]$Path
	
	WebServer () {
		trap { $this.Destroy() }
		$this.Server = [System.Net.Sockets.TcpListener]::new( 4000 )
		$this.AcceptSocket()
		$this.ReadAddress()
	}
	WebServer ( [int]$port ) {
		trap { $this.Destroy() }
		$this.Server = [System.Net.Sockets.TcpListener]::new( $port )
		$this.AcceptSocket()
		$this.ReadAddress()
	}
	WebServer ( [string]$path ) {
		trap { $this.Destroy() }
		$this.Server = [System.Net.Sockets.TcpListener]::new( 4000 )
		$this.Path = $path
		$this.AcceptSocket()
		$this.ReadAddress()
	}

	WebServer ( $port, $path ) {
		trap { $this.Destroy() }
		$this.Server = [System.Net.Sockets.TcpListener]::new( $port )
		$this.Path = $path
		$this.AcceptSocket()
		$this.ReadAddress()
	}
	[void]AcceptSocket() {
		$this.Server.Start()
		$this.ClientSocket = $this.Server.AcceptSocket()
	}
	[void]ReadAddress(){
		$bytes = [byte[]]::new(0)
		while ( $this.ClientSocket.Availabe ) {
			$this.ClientSocket.Receive( ( $buffer = [byte[]]::new( $this.Socket.Available ) ) )
			$bytes += $buffer
		}
		$this.SendResponse()
		$this.Address =  ( [string]::new( $bytes ) -split " " )[1]
	}
	[void]SendResponse(){
		$Response = 	"HTTP/1.1 200 OK`n`n" +
				"Hallo" 
		$this.ClientSocket.Send( $Response.toCharArray() ) 
		$this.ClientSocket.Disconnect( 0 )
	}
	[void]Destroy() {
		$this.Server.Stop()
		$this.Server.Server.Dispose()
		$this.Server = $null
	}
}
