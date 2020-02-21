library(ggplot2)
library(hexSticker)

set.seed(2019)
p <- ggplot(data.frame(word = sample(ICD10gm::icd_meta_codes$icd_normcode, 6)),
            aes(label = word)) +
  ggwordcloud::geom_text_wordcloud(family = "mono",
                                   seed = 10,
                                   shape = "circle",
                                   size = 11,
                                   eccentricity = 0.89,
                                   grid_size = 6,
                                   grid_margin = 6,
                                   perc_step = 0.75,
                                   rm_outside = TRUE) +
  theme_void() + theme_transparent()


# dimdi Blue: #337299
# dimdi orange: #f28502
#sysfonts::font_add("inconsolata", regular = "/usr/share/fonts/truetype/inconsolata/Inconsolata.otf")

sticker(p, package="ICD10gm", p_size=28, p_family = "serif", p_y = 1.35,
        s_x=1, s_y=.75, s_width=1.4, s_height=1,
        h_fill = "#007FFF", h_color = "#FF8000",
        filename="man/figures/logo.png")
# filename="inst/figures/ICD10gm.png")

