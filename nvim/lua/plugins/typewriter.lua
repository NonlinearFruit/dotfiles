local function configure()
  require("prototypes.typewriter").setup()
end

return {
  "prototypes/typewriter",
  config = configure,
  dev = true,
}
