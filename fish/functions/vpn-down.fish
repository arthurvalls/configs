function vpn-down --description 'Disconnect the SuperSim openvpn3 VPN session'
    openvpn3 session-manage --config arthur.valls --disconnect
end
