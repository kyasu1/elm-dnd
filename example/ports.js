window.elm.ports.addEventListener.subscribe(function(id) {
    var node = document.getElementById(id);

    if (node) {
        node.addEventListener('dragstart', handleDragStart, false);

        function handleDragStart(e) {
            e.dataTransfer.effectAllowed = 'move';
            e.dataTransfer.setData('text/plain', id);
        }
    }
});
