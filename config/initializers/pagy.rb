require "pagy/extras/bootstrap"

Pagy::I18n.load({locale: "en"},
                {locale: "vi",
                 filepath: Rails.root.join("config/locales/pagy-vi.yml")})

# When you are done setting your own default freeze it, so it will not get changed accidentally
Pagy::DEFAULT.freeze
