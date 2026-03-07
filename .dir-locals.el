((nil . ((eglot-workspace-configuration
          . (:nixd (:nixpkgs (:expr "import <nixpkgs> { }"))
                   ;; (:nixos (:expr "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.nas.options"))
                   ;; (:options (:home-manager
                   ;;            (:expr "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.nas.options.home-manager.users.type.getSubOptions []")))
                   )))))
