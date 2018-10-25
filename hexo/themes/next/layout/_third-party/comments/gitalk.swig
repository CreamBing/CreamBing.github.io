{% if theme.gitalk.enable %}

  {% if theme.gitalk.distractionFreeMode  %}
    <link rel='stylesheet' href="https://cdn.jsdelivr.net/npm/gitalk@1/dist/gitalk.css">
    <script src="https://cdn.jsdelivr.net/npm/gitalk@1/dist/gitalk.min.js"></script>
    <script src="https://cdn.bootcss.com/blueimp-md5/2.10.0/js/md5.js"></script>
    <script type="text/javascript">
        var gitalk = new Gitalk({
          clientID:  '{{theme.gitalk.clientID}}',
          clientSecret: '{{theme.gitalk.clientSecret}}',
          id: md5(window.location.pathname),
          repo: '{{theme.gitalk.repo}}',
          owner: '{{theme.gitalk.owner}}',
          admin: '{{theme.gitalk.admin}}',
          distractionFreeMode: '{{theme.gitalk.distractionFreeMode}}',
        })
        gitalk.render('gitalk-container')
    </script>
  {% endif %}

{% endif %}

