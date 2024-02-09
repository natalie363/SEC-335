param ($subnet, $server)

for ($i = 0; $i -lt 254; $i++) {
    $ip = $subnet + '.' + $i
    $hostname = Resolve-DnsName -DnsOnly $ip -Server $server -ErrorAction Ignore
    if ($? -eq $True) {
        write-host $ip $hostname.NameHost
    }
}