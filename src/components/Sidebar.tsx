import { PropsWithChildren } from 'react';

import BackButton from './BackButton';

function Sidebar({ children }: PropsWithChildren) {
  return (
    <aside className="desktop:sticky desktop:grid desktop:gap-[20px] desktop:top-[90px] hidden">
      <BackButton />
      {children}
    </aside>
  );
}

export default Sidebar;
