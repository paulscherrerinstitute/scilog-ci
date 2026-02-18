const { HttpErrors } = require("@loopback/rest");

function roles(profile) {
  if (!profile._json?.clientRoles?.includes("scilog"))
    throw new HttpErrors.Unauthorized(
      "User is not authorized to access scilog",
    );
  if (profile.username && /^e[0-9]{5}$/.test(profile.username ?? ""))
    return (profile._json?.roles ?? []).concat([
      "p" + profile.username?.substring(1),
    ]);
  else return profile._json?.roles ?? [];
}

exports.roles = roles;
