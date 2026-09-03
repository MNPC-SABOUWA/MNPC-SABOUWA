document.addEventListener("DOMContentLoaded", function () {

    // Animations au defilement
    const animatedElements = document.querySelectorAll(
        ".info-card, .news-placeholder, .vision-box, .app-text, .phone, .contact-box"
    );

    if ("IntersectionObserver" in window) {

        const observer = new IntersectionObserver(function (entries) {

            entries.forEach(function (entry) {

                if (entry.isIntersecting) {
                    entry.target.classList.add("visible");
                    observer.unobserve(entry.target);
                }

            });

        }, {
            threshold: 0.12
        });

        animatedElements.forEach(function (element) {
            observer.observe(element);
        });

    } else {

        animatedElements.forEach(function (element) {
            element.classList.add("visible");
        });

    }


    // Navigation fluide
    document.querySelectorAll('a[href^="#"]').forEach(function (link) {

        link.addEventListener("click", function (event) {

            const targetId = this.getAttribute("href");

            if (!targetId || targetId === "#") {
                return;
            }

            const target = document.querySelector(targetId);

            if (!target) {
                return;
            }

            event.preventDefault();

            const header = document.querySelector(".header");
            const headerHeight = header
                ? header.getBoundingClientRect().height
                : 0;

            const position =
                target.getBoundingClientRect().top +
                window.scrollY -
                headerHeight -
                15;

            window.scrollTo({
                top: Math.max(0, position),
                behavior: "smooth"
            });

        });

    });


    // Boutons vers l'accueil
    document.querySelectorAll('a[href="#accueil"]').forEach(function (link) {

        link.addEventListener("click", function (event) {

            event.preventDefault();

            window.scrollTo({
                top: 0,
                behavior: "smooth"
            });

        });

    });


    // Telechargement de l'application
    document.querySelectorAll(
        'a[href*="github.com"][href*="/releases/latest"]'
    ).forEach(function (link) {

        link.setAttribute("target", "_blank");
        link.setAttribute("rel", "noopener noreferrer");

    });

});