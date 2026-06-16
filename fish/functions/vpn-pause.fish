function vpn-pause --description 'Suspend the VPN session without dropping it (resume needs no code)'
    openvpn3 session-manage --config arthur.valls --pause
end
