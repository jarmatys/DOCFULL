param (
    [switch] $mssql,
    [switch] $proxy,
    [switch] $qdrant,
    [switch] $rabbit,
    [switch] $seq,
    [switch] $typesense
)

if ($mssql)
{
    docker compose -f .\docker-compose.mssql.yml up -d
}
elseif ($proxy)
{
    docker compose -f .\docker-compose.proxy.yml up -d
}
elseif ($qdrant)
{
    docker compose -f .\docker-compose.qdrant.yml up -d
}
elseif ($rabbit)
{
    docker compose -f .\docker-compose.rabbit.yml up -d
}
elseif ($seq)
{
    docker compose -f .\docker-compose.seq.yml up -d
}
elseif ($typesense)
{
    docker compose -f .\docker-compose.typesense.yml up -d
}
else
{
    Write-Host "Please provide a profile to start the enviroment: -mssql, -proxy, -qdrant, -rabbit, -seq, -typesense"
}