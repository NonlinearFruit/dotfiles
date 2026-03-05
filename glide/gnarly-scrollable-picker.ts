glide.keymaps.set("normal", "gs", () => {
  glide.hints.show({
    selector: elements_that_could_scroll,
    pick: pick_elements_that_are_overflowing,
    action: scroll_to_element_and_focus
  });
}, { description: "[g]obsmacked find [s]crollable elements" });

const elements_that_could_scroll =  "div, section, article, aside, nav, ul, ol, pre, code, main, textarea, [class*='scroll']"

async function pick_elements_that_are_overflowing({ content, hints}) {
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
}

async function scroll_to_element_and_focus({ content }) {
  await content.execute((element: HTMLElement) => {
    element.scrollIntoView({ block: "center", behavior: "smooth" });

    if (!element.hasAttribute("tabindex")) {
      element.setAttribute("tabindex", "-1");
    }
    element.focus();
  });
}
