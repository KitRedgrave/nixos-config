{ config, lib, inputs, pkgs, systems, ... }:

{
  sops.secrets = {
    wifi-key = {
      format = "binary";
      sopsFile = inputs.self + "/secrets/home-wifi.enc";
    };
  };
  networking.wireless = {
    enable = true;
    secretsFile = config.sops.secrets.wifi-key.path;
    networks."Temp Wifi".pskRaw = "ext:psk_home";
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC1u57T9mio+04M7qU0ERvd0Kz1jN7RCxleVe141HcGeoToWVwDZjxcIzmfLBKCaSkOOT9IyWpzmsj7OH+1oOiCq9oa6PCxh//FWeTSb5Jjnpu8Lu8AsMnqZ3vMpfGliHoi/5l3CTS1ai7Pepvy1R7m0l1DQUoJk8+bcsg5ErmjLA2l2wNRtsAC/vqrtE8qtPq3UNtKSTcA+iQD7SIrvSxUJJ8ZKLSSQlTtjstC18+C2sMk45DQyw3iV1e93UJVX1UpJxog4KOgt4vfhRZkngs22f6AUbTn+3r7vtYOBaJJp3VytcSwT+srpsSAzwnDiz20qpfKqchXC3LoDWWGrSOOc8+KMFxWw2COIcFK4JBOfvZWftFBT6HjKgPIywjG4L9eVu03TSG8CFMAbb/mWeqN9yFUlBt5dcMhDA0L3bx69X/i90tE4h7ajH6IRFDlfWWRPt4X1TwbMzLW10fZhPt8mqK5a2rnIGtIJm3TAdt2Aokq6Iw1pvFNY9/6E2IG1B2sw3hyqi9jHM52hFZAncUBmF6TWO0tvpvr4XDt8pomvpxbIob2ypd5xjsLYNI3VA27nM6IsFqR+X5ncElkmKLDbqagX81vcxINho5FmljNt51aIKbxMjJZ3KYq2aR0KzEYqnaWiht0VYPwoqSZIXynurrSDOATDuh0CQH+Ggjjfw== cardno:24_736_654"
  ];
}
