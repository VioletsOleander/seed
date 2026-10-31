function proxy --description "Manipulate proxy environment variables"
    switch $argv[1]
        case toggle
            if not set --query proxy_on
                if not test -e ~/.local/share/user/proxy.txt
                    echo error: file ~/.local/share/user/proxy.txt not found
                    return 1
                end

                set --local url (cat ~/.local/share/user/proxy.txt)

                set --global --export http_proxy $url
                set --global --export https_proxy $url
                set --global --export no_proxy localhost,127.0.0.1,::1

                set --global proxy_on

                echo successfully enabled proxy as $url
            else
                set --local url (cat ~/.local/share/user/proxy.txt)

                set --global --unexport http_proxy
                set --global --unexport https_proxy
                set --global --unexport no_proxy

                set --erase --global proxy_on

                echo successfully disabled proxy
            end
        case status
            echo http_proxy: $http_proxy
            echo https_proxy: $https_proxy
            echo no_proxy: $no_proxy
        case '*'
            echo error: the subcommand should be toggle or status
            return 1
    end
end
