let
  listVimPlugins = allPlugins: (
    map (p: { name = p.pname; path = "${p}"; }) allPlugins
  );

  formatAsLua = builtins.foldl' (acc: elem: acc + '' ['${elem.name}'] = '${elem.path}', '') "";

  plugins = (builtins.getFlake (toString ./.)).packages.x86_64-linux.allPlugins;
in
"local p = {" + formatAsLua (listVimPlugins plugins) + "}"
