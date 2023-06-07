# frozen_string_literal: true

def create_platform_hooks
  nginx_config
end

def nginx_config
  file '.platform/nginx/conf.d/set_up.conf', <<~CODE
    keepalive_timeout 300s;
    proxy_connect_timeout 300s;
    proxy_send_timeout 300s;
    proxy_read_timeout 300s;
    fastcgi_send_timeout 300s;
    fastcgi_read_timeout 300s;
    client_max_body_size 20M;
  CODE
end
