function vpn-up --description 'Connect to SuperSim VPN as a persistent session (re-auth rarely)'
    # --persist-tun keeps the tunnel alive across network blips / sleep.
    # You enter user/pass/Authy code once; the session then stays up.
    openvpn3 session-start --config arthur.valls --persist-tun
end
