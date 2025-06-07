interface Props {
  title: string;
  date: string;
}

function ArticleCard({ title, date }: Props) {
  return (
    <article className="flex justify-between content-center py-[10px] px-[12px] transition-all duration-400 rounded-[6px] cursor-pointer hover:bg-gray-500">
      <h1 className="text-[15px] font-normal m-[0px]">{title}</h1>
      <time dateTime={date} className="text-[13px] font-light">
        {new Date(date).getFullYear()}
      </time>
    </article>
  );
}

export default ArticleCard;
