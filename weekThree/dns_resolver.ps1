param ($subnet, $server)

for ($i = 0; $i -le 255; $i++) {
    $ip = $subnet + '.' + $i
    $hostname = Resolve-DnsName -DnsOnly $ip -Server $server -ErrorAction Ignore
    if ($? -eq $True) {
        write-host $ip $hostname.NameHost
    }
}