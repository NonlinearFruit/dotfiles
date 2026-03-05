glide.keymaps.set("normal", "gs", () => {
    glide.hints.show({
        selector: "div, section, article, aside, nav, ul, ol, pre, code, main, textarea, [class*='scroll']",

        pick: async ({ content, hints }) => {
            const results = await content.map((element: HTMLElement) => {
                const style = window.getComputedStyle(element);

                const overflowY = style.overflowY;
                const overflowX = style.overflowX;
                const isScrollableStyle =
                    (overflowY === 'auto' || overflowY === 'scroll') ||
                    (overflowX === 'auto' || overflowX === 'scroll');

                const canScroll =
                    element.scrollHeight > element.clientHeight ||
                    element.scrollWidth > element.clientWidth;

                const hasScrollClass = element.className.includes("scroll");
                const isNotRoot = element !== document.body && element !== document.documentElement;

                return (isScrollableStyle || hasScrollClass) && canScroll && isNotRoot;
            });

            const filteredHints = hints.filter((_, i) => results[i]);

            if (filteredHints.length === 0) {
                glide.excmds.execute("hints_remove");
                glide.excmds.execute("mode_change normal");
            }

            return filteredHints;
        },

        action: async ({ content }) => {
            await content.execute((element: HTMLElement) => {
                element.scrollIntoView({ block: "center", behavior: "smooth" });

                if (!element.hasAttribute("tabindex")) {
                    element.setAttribute("tabindex", "-1");
                }
                element.focus();
            });
        }
    });
}, { description: "Focus scrollable elements" });
