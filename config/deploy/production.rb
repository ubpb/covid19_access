server "ubpegasus18.upb.de", user: "ubpb", roles: %w{app web db}
server "ubperseus18.upb.de", user: "ubpb", roles: %w{app web}
server "ubatch18.upb.de",    user: "ubpb", roles: %w{app db}
set :deploy_to, "/ubpb/covid19access"
set :branch, "production"
