function outp_prisma(io,byte)

unix(sprintf('~/bin/write_parport_prisma %i',byte));

WaitSecs(io.triggerLength);

unix(sprintf('~/bin/write_parport_prisma %i',0));

end