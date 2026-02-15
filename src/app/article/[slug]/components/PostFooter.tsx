import Comment from './Comment';

function PostFooter() {
  return (
    <footer
      id="comments-footer"
      className="border-gray-9 tablet:col-start-2 tablet:col-end-3 dark:border-gray-6 mt-6 border-t pt-6 text-lg"
    >
      <Comment />
    </footer>
  );
}

export default PostFooter;
