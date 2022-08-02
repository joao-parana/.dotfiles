function find_process_by_port
    sudo ss -lptn "sport = :$argv"
end