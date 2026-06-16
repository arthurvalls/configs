function vpn-resume --description 'Resume a paused VPN session (reuses the existing login, no Authy code)'
    openvpn3 session-manage --config arthur.valls --resume
end
