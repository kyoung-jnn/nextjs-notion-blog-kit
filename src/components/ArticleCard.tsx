interface Props {
  title: string;
  date: string;
}

function ArticleCard({ title, date }: Props) {
  return (
    <article className="flex cursor-pointer content-center justify-between rounded-[6px] px-[12px] py-[10px] transition-all duration-400 hover:bg-gray-300">
      <h1 className="m-[0px] text-[15px] font-normal">{title}</h1>
      <time dateTime={date} className="text-[13px] font-light">
        {new Date(date).getFullYear()}
      </time>
    </article>
  );
}

export default ArticleCard;
