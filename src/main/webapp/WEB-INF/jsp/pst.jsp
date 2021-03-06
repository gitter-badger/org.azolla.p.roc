<%@ page language="java" pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>${post.title} - ${applicationScope.CONFIG_MAP["ROC_CONFIG_KEY_ROCTITLE"]}</title>
    <%@ include file="/WEB-INF/ref/head.jsp"%>
</head>
<body>
<jsp:include page="/WEB-INF/ref/nav.jsp" />
<div id="roc-i-content">
    <div class="container">
        <div class="row">
            <main class="col-md-9">
                <article class="roc-c-article-post">
                    <section class="bs-docs-section">
                        <input type="hidden" id="postId" name="postId" value="${post.id}" />
                        <h2 class="page-header" id="${post.urlTitle}">${post.title}
                            <small>
                                <time><fmt:formatDate value="${post.addDate}" type="both" pattern="yyyy-MM-dd" /></time>
                            </small>
                        </h2>
                        ${post.content}
                        <c:if test="${fn:length(post.tagVoList) > 0}">
                            <div class="bs-callout bs-callout-info">
                                <h4>Tag</h4>
                                <div class="roc-c-div-tag">
                                    <c:forEach var="tag" items="${post.tagVoList}">
                                        <a href="/tag/${tag.urlName}">${tag.displayName}</a>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>
                        <c:if test="${post.operable == 1 || fn:length(post.commentVoList) > 0}">
                            <div class="bs-callout bs-callout-warning" id="list_comment_prepend">
                                <c:if test="${fn:length(post.commentVoList) > 0}">
                                    <h4>Comment</h4>
                                    <ul class="media-list" id="list_comment">
                                        <c:forEach var="comment" items="${post.commentVoList}">
                                            <li class="media">
                                                <div class="media-left">
                                                    <img class="media-object" src="/generate/img/qrcode/${comment.email}.png" />
                                                </div>
                                                <div class="media-body">
                                                    <h4 class="media-heading">${comment.username}</h4>
                                                    <p id="comment_${comment.postId}_${comment.id}">${fn:replace(fn:replace(fn:replace(fn:replace(comment.content, '&', '&amp;'),'<','&lt;'),'>','&gt;'),'\"','&quot;')}</p>
                                                </div>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </c:if>
                                <c:if test="${post.operable == 1}">
                                    <h4>New</h4>
                                    <form class="form-horizontal" onsubmit="return onSubmitButton()">
                                        <div class="form-group">
                                            <label for="commentName" class="col-sm-1 control-label">Name</label>
                                            <div class="col-sm-11">
                                                <input type="text" class="form-control" id="commentName" name="commentName" placeholder="Name" required="required" />
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="commentEmail" class="col-sm-1 control-label">Email</label>
                                            <div class="col-sm-11">
                                                <input type="email" class="form-control" id="commentEmail" name="commentEmail" placeholder="Email" required="required" />
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="col-sm-offset-1 col-sm-11">
                                                <textarea class="form-control" id="commentContent" name="commentContent" rows="3" required="required"></textarea>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <div class="col-sm-offset-1 col-sm-11">
                                                <button type="submit" class="btn btn-default">Submit</button>
                                            </div>
                                        </div>
                                    </form>
                                </c:if>
                            </div>
                        </c:if>
                    </section>
                </article>
            </main>
            <aside class="col-md-3 hidden-print hidden-xs hidden-sm" id="aside_comment_append">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h3 class="panel-title">Tag</h3>
                    </div>
                    <div class="panel-body roc-c-div-tag">
                        <c:forEach var="tag" items="${applicationScope.TAG_LST}">
                            <a href="/tag/${tag.urlName}">${tag.displayName}</a>
                        </c:forEach>
                    </div>
                </div>
                <c:if test="${fn:length(post.commentVoList) > 0}">
                    <div class="panel panel-default bs-docs-sidebar affix-top">
                        <div class="panel-heading">
                            <h3 class="panel-title">Comment</h3>
                        </div>
                        <div class="panel-body">
                            <ul class="nav bs-docs-sidenav" id="aside_comment">
                                <c:forEach var="comment" items="${post.commentVoList}">
                                    <li><a href="#comment_${comment.postId}_${comment.id}">${fn:replace(fn:replace(fn:replace(fn:replace(comment.content, '&', '&amp;'),'<','&lt;'),'>','&gt;'),'\"','&quot;')}</a></li>
                                </c:forEach>
                            </ul>
                        </div>
                    </div>
                </c:if>
            </aside>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/ref/footer.jsp" %>
<script>
    function onSubmitButton(){
        $.post("/ajax/comment/add",{postId:$("#postId").val(),commentName:$("#commentName").val(),commentEmail:$("#commentEmail").val(),commentContent:$("#commentContent").val()},function(result){
            var data = eval("("+result+")");
            if (data.err === 0) {
                var list_comment = "";
                list_comment = list_comment + "<li class=\"media\">";
                list_comment = list_comment + "<div class=\"media-left\">";
                list_comment = list_comment + "<img class=\"media-object\" src=\"/generate/img/qrcode/"+data.rst.email+".png\" />";
                list_comment = list_comment + "</div>";
                list_comment = list_comment + "<div class=\"media-body\">";
                list_comment = list_comment + "<h4 class=\"media-heading\">"+data.rst.username+"</h4>";
                list_comment = list_comment + "<p id=\"comment_"+data.rst.postId+"_"+data.rst.id+"\">"+data.rst.content+"</p>";
                list_comment = list_comment + "</div>";
                list_comment = list_comment + "</li>";
                if($("#list_comment").val() == undefined){
                    var list_comment_prepend = "";
                    list_comment_prepend = list_comment_prepend + "<h4>Comment</h4>";
                    list_comment_prepend = list_comment_prepend + "<ul class=\"media-list\" id=\"list_comment\">";
                    list_comment_prepend = list_comment_prepend + list_comment;
                    list_comment_prepend = list_comment_prepend + "</ul>";

                    $("#list_comment_prepend").prepend(list_comment_prepend);
                }else{
                    $("#list_comment").append(list_comment);
                }

                var aside_comment = "";
                aside_comment = aside_comment + " <li><a href=\"#comment_"+data.rst.postId+"_"+data.rst.id+"\">"+data.rst.content+"</a></li>";
                if($("#aside_comment").val() == undefined){
                    var aside_comment_append = "";
                    aside_comment_append = aside_comment_append + "<div class=\"panel panel-default bs-docs-sidebar affix-top\">";
                    aside_comment_append = aside_comment_append + "<div class=\"panel-heading\">";
                    aside_comment_append = aside_comment_append + "<h3 class=\"panel-title\">Comment</h3>";
                    aside_comment_append = aside_comment_append + "</div>";
                    aside_comment_append = aside_comment_append + "<div class=\"panel-body\">";
                    aside_comment_append = aside_comment_append + "<ul class=\"nav bs-docs-sidenav\" id=\"aside_comment\">";
                    aside_comment_append = aside_comment_append + aside_comment;
                    aside_comment_append = aside_comment_append + "</ul>";
                    aside_comment_append = aside_comment_append + "</div>";
                    aside_comment_append = aside_comment_append + "</div>";

                    $("#aside_comment_append").append(aside_comment_append);
                }else{
                    $("#aside_comment").append(aside_comment);
                }

                $("#commentName").val("");
                $("#commentEmail").val("");
                $("#commentContent").val("");
            } else {
                alert(data.msg);
            }
        });
        return false;
    }
</script>
</body>
</html>