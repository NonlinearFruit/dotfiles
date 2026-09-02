const redirects = [
  {
    redirect_to: "meme.vern.cc",
    redirect_from: [
           "knowyourmeme.com",
    ],
  },
  {
    redirect_to: "biblioreads.eu.org",
    redirect_from: [
           "www.goodreads.com",
           "goodreads.com",
    ],
  },
  {
    redirect_to: "red.chatoyer.de",
    redirect_from: [
           "www.reddit.com",
           "reddit.com",
    ],
  },
  {
    redirect_to: "gh.bloat.cat",
    redirect_from: [
           "gist.github.com",
    ],
  },
]

glide.autocmds.create("ConfigLoaded", async () => {
  for (const [id, redirect] of redirects.entries())
    // id is 0 is ignored
    await configureRedirect(id+1, redirect.redirect_to, redirect.redirect_from)
});

async function configureRedirect(id, redirect_to, redirect_froms) {
  await browser.declarativeNetRequest.updateDynamicRules({
   removeRuleIds: [id],
   addRules: [
     {
       id: id,
       priority: 1,
       action: {
         type: "redirect",
         redirect: { transform: { host: redirect_to} },
       },
       condition: {
         requestDomains: redirect_froms,
         resourceTypes: ["main_frame"],
       },
     },
   ],
  })
}
